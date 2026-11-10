#!/bin/sh
# Give an agent's sidebar row a per-state Nerd Font icon.
# herdr swaps the icon itself on each state change; this only has to run once
# per agent session. Colors live in config.toml under [ui.sidebar.agents.rows_by_agent].
#
# Usage: agent-icons.sh <claude|omp|codex>
# Called from Claude Code's SessionStart hook and ~/.omp/agent/extensions/herdr-icons.ts.

agent="${1:-}"
[ -n "$agent" ] || exit 0
[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0

# --agent guards the labels: they only show while this agent runs in the pane.
herdr pane report-metadata "$HERDR_PANE_ID" \
  --source "icons:$agent" --agent "$agent" \
  --state-label 'working= ' \
  --state-label 'done=󱜚 ' \
  --state-label 'blocked=󱚝 ' \
  --state-label 'idle=󱚠 ' \
  --state-label 'unknown=󱚢 ' \
  >/dev/null 2>&1 || true
