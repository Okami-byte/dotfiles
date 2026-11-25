#!/usr/bin/env python3
"""Push tmux coding-agent status to sketchybar (tmux twin of agent_watch.py).

Usage:
  agent_watch_tmux.py <sketchybar_event> [sketchybar_bin] [tmux_bin]   watch
  agent_watch_tmux.py --list [tmux_bin]                                print JSON

Status source: the pane option @agent_status, written by
helpers/tmux_agent_hook.sh from Claude Code hooks (idle / working / blocked /
done). Panes running a known agent binary without that option count as
"unknown". The hook sends SIGUSR1 so updates are instant; a short poll is the
safety net (tmux has no event stream we can listen on without attaching).

"done" turns into "idle" once you look at the pane, like herdr's unseen state.

Trigger env vars: STATUS (most urgent: blocked > working > done > idle >
unknown, or "none"), COUNT (agents in that status), TOTAL (all agents).
"""

import json
import re
import signal
import subprocess
import sys
import threading

PRIORITY = ["blocked", "working", "done", "idle", "unknown"]
POLL_SECS = 3  # safety-net re-list; hooks wake us immediately
RETRY_SECS = 5  # no tmux server: try again after this long
DEBOUNCE_SECS = 0.1  # let bursts of hook calls settle

# pane_current_command values that mean "an agent runs here". Claude Code's
# process title is its version number (e.g. 2.1.332).
AGENT_CMDS = {"claude", "codex", "omp", "opencode", "amp", "gemini", "droid", "pi"}
VERSION_RE = re.compile(r"^\d+\.\d+\.\d+")
SHELLS = {"fish", "zsh", "bash", "sh", "dash", "nu", "login"}
# Claude prefixes its title with a status glyph (✳ or a braille spinner).
TITLE_GLYPH_RE = re.compile(r"^[⠀-⣿✳✻✢·*✢✶✻✽]+\s*")

FIELDS = [
    "pane_id",
    "session_name",
    "window_index",
    "pane_active",
    "window_active",
    "pane_current_command",
    "pane_title",
    "pane_current_path",
    "@agent_status",
    "@agent_name",
]
FORMAT = "\x1f".join("#{" + f + "}" for f in FIELDS)

wake = threading.Event()


def tmux(bin_, *args):
    return subprocess.run([bin_, *args], capture_output=True, text=True, timeout=5)


def agent_name(cmd, name):
    if name:
        return name
    if VERSION_RE.match(cmd):
        return "claude"
    return cmd if cmd in AGENT_CMDS else None


def list_agents(tmux_bin, mark_seen=False):
    out = tmux(tmux_bin, "list-panes", "-a", "-F", FORMAT)
    if out.returncode != 0:
        raise ConnectionError(out.stderr.strip() or "tmux not running")

    # "Looking at it" = active pane of the session shown by the client you
    # used last; merely being attached somewhere doesn't count.
    clients = tmux(tmux_bin, "list-clients", "-F", "#{client_activity} #{client_session}").stdout.split("\n")
    clients = [c.split(" ", 1) for c in clients if " " in c]
    current = max(clients, key=lambda c: int(c[0]))[1] if clients else None

    agents = []
    for line in out.stdout.splitlines():
        p = dict(zip(FIELDS, line.split("\x1f")))
        cmd, status = p["pane_current_command"], p["@agent_status"]
        name = agent_name(cmd, p["@agent_name"])

        if status and cmd in SHELLS:
            # Agent exited without SessionEnd (crash, kill): drop stale state.
            tmux(tmux_bin, "set", "-p", "-t", p["pane_id"], "-u", "@agent_status")
            continue
        if not status and not name:
            continue
        status = status or "unknown"

        focused = p["pane_active"] == "1" and p["window_active"] == "1" and p["session_name"] == current
        if mark_seen and status == "done" and focused:
            tmux(tmux_bin, "set", "-p", "-t", p["pane_id"], "@agent_status", "idle")
            status = "idle"

        agents.append(
            {
                "pane_id": p["pane_id"],
                "agent": name or "agent",
                "agent_status": status,
                "title": TITLE_GLYPH_RE.sub("", p["pane_title"]).strip(),
                "session": p["session_name"],
                "cwd": p["pane_current_path"],
            }
        )

    rank = {s: i for i, s in enumerate(PRIORITY)}
    agents.sort(key=lambda a: rank.get(a["agent_status"], len(PRIORITY)))
    return agents


def summarize(agents):
    counts = {}
    for a in agents:
        counts[a["agent_status"]] = counts.get(a["agent_status"], 0) + 1
    top = next((p for p in PRIORITY if counts.get(p)), "none")
    return {"STATUS": top, "COUNT": counts.get(top, 0), "TOTAL": len(agents)}


def trigger(sketchybar, event, summary, last):
    if summary == last:
        return last
    subprocess.run(
        [sketchybar, "--trigger", event] + [f"{k}={v}" for k, v in summary.items()],
        check=False,
    )
    return summary


def watch(event, sketchybar, tmux_bin):
    signal.signal(signal.SIGUSR1, lambda *_: wake.set())
    last = None
    while True:
        try:
            last = trigger(sketchybar, event, summarize(list_agents(tmux_bin, mark_seen=True)), last)
            delay = POLL_SECS
        except (OSError, ConnectionError, subprocess.TimeoutExpired):
            last = trigger(sketchybar, event, {"STATUS": "none", "COUNT": 0, "TOTAL": 0}, last)
            delay = RETRY_SECS
        if wake.wait(delay):
            wake.clear()
            wake.wait(DEBOUNCE_SECS)
            wake.clear()


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--list":
        tmux_bin = sys.argv[2] if len(sys.argv) > 2 else "tmux"
        try:
            agents = list_agents(tmux_bin)
        except (OSError, ConnectionError, subprocess.TimeoutExpired):
            agents = []
        print(json.dumps({"agents": agents}))
        return

    event = sys.argv[1] if len(sys.argv) > 1 else "agents_update"
    sketchybar = sys.argv[2] if len(sys.argv) > 2 else "sketchybar"
    tmux_bin = sys.argv[3] if len(sys.argv) > 3 else "tmux"
    watch(event, sketchybar, tmux_bin)


if __name__ == "__main__":
    main()
