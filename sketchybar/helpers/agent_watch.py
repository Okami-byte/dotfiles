#!/usr/bin/env python3
"""Push herdr agent status to sketchybar, driven by herdr's socket events.

Usage: agent_watch.py <sketchybar_event> [sketchybar_bin]

Loop: list agents -> trigger <event> with a summary -> subscribe to status
changes for every agent pane (herdr requires a pane_id per subscription) plus
agent-detected / pane-closed / pane-exited -> block until any event arrives ->
repeat. A periodic timeout re-lists anyway, so nothing can go stale.

Trigger env vars: STATUS (most urgent: blocked > working > done > idle >
unknown, or "none"), COUNT (agents in that status), TOTAL (all agents).
"""

import json
import os
import socket
import subprocess
import sys
import time

PRIORITY = ["blocked", "working", "done", "idle", "unknown"]
RESYNC_SECS = 60  # re-list even without events, as a safety net
RETRY_SECS = 5  # herdr not running: try again after this long
DEBOUNCE_SECS = 0.15  # let bursts of events settle before re-listing

EVENT = sys.argv[1] if len(sys.argv) > 1 else "agents_update"
SKETCHYBAR = sys.argv[2] if len(sys.argv) > 2 else "sketchybar"
SOCK = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser("~/.config/herdr/herdr.sock")


def connect(timeout):
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.settimeout(timeout)
    s.connect(SOCK)
    return s


def request(sock, method, params):
    sock.sendall((json.dumps({"id": method, "method": method, "params": params}) + "\n").encode())


def read_line(reader):
    line = reader.readline()
    if not line:
        raise ConnectionError("herdr closed the socket")
    return json.loads(line)


def list_agents():
    with connect(5) as s, s.makefile("r") as reader:
        request(s, "agent.list", {})
        return read_line(reader)["result"]["agents"]


def trigger(summary, last):
    if summary == last:
        return last
    subprocess.run(
        [SKETCHYBAR, "--trigger", EVENT] + [f"{k}={v}" for k, v in summary.items()],
        check=False,
    )
    return summary


def summarize(agents):
    counts = {}
    for a in agents:
        status = a.get("agent_status", "unknown")
        counts[status] = counts.get(status, 0) + 1
    top = next((p for p in PRIORITY if counts.get(p)), "none")
    return {"STATUS": top, "COUNT": counts.get(top, 0), "TOTAL": len(agents)}


def wait_for_change(agents):
    subs = [{"type": "pane.agent_detected"}, {"type": "pane.closed"}, {"type": "pane.exited"}]
    subs += [{"type": "pane.agent_status_changed", "pane_id": a["pane_id"]} for a in agents]
    with connect(RESYNC_SECS) as s, s.makefile("r") as reader:
        request(s, "events.subscribe", {"subscriptions": subs})
        reply = read_line(reader)
        if "error" in reply:
            raise ConnectionError(reply["error"].get("message", "subscribe failed"))
        try:
            read_line(reader)  # any event at all means "re-list"
        except socket.timeout:
            pass


def main():
    last = None
    while True:
        try:
            agents = list_agents()
            last = trigger(summarize(agents), last)
            wait_for_change(agents)
            time.sleep(DEBOUNCE_SECS)
        except (OSError, ConnectionError, ValueError, KeyError):
            last = trigger({"STATUS": "none", "COUNT": 0, "TOTAL": 0}, last)
            time.sleep(RETRY_SECS)


if __name__ == "__main__":
    main()
