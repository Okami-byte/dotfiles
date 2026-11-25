#!/bin/sh
# Claude Code hook -> tmux pane option @agent_status, read by
# helpers/agent_watch_tmux.py for the sketchybar agents item.
#
# Usage: tmux_agent_hook.sh <idle|working|blocked|done|off> [agent_name]
# Wired up in ~/.claude/settings.json (SessionStart, UserPromptSubmit,
# PostToolUse, Notification, Stop, SessionEnd). Other agents can call it too.

cat >/dev/null 2>&1 # drain the hook payload
[ -n "${TMUX_PANE:-}" ] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

status="${1:-}"
agent="${2:-claude}"

if [ "$status" = "off" ]; then
	tmux set -p -t "$TMUX_PANE" -u @agent_status \; set -p -t "$TMUX_PANE" -u @agent_name 2>/dev/null
else
	tmux set -p -t "$TMUX_PANE" @agent_status "$status" \; set -p -t "$TMUX_PANE" @agent_name "$agent" 2>/dev/null
fi

# Wake the watcher so the bar updates now instead of on its next poll.
pid=$(cat "${TMPDIR:-/tmp}/sketchybar/agent_pids" 2>/dev/null) &&
	ps -p "$pid" -o command= 2>/dev/null | grep -q agent_watch_tmux.py &&
	kill -USR1 "$pid" 2>/dev/null
exit 0
