#!/usr/bin/env bash
# Morning pipeline check for the dotfiles repo.
# Run by the Claude Code SessionStart hook; stdout is handed to Claude as context.
# Prints nothing if it already ran today (use --force to override).
set -uo pipefail

repo="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
cd "$repo" || exit 0

stamp_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-morning"
stamp="$stamp_dir/$(date +%F)"
if [[ "${1:-}" != "--force" && -e "$stamp" ]]; then
  exit 0
fi
mkdir -p "$stamp_dir"
touch "$stamp"

echo "# Dotfiles morning check ($(date +%F))"
echo
echo "Follow the playbook in .claude/morning-review.md using the findings below."
echo

echo "## Latest CI runs (main + open PRs)"
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  gh run list --limit 5 --json workflowName,conclusion,status,headBranch,event,databaseId,createdAt \
    --template '{{range .}}{{.workflowName}} | {{.headBranch}} | {{.event}} | {{if .conclusion}}{{.conclusion}}{{else}}{{.status}}{{end}} | run {{printf "%.0f" .databaseId}} | {{.createdAt}}{{"\n"}}{{end}}' 2>&1
  echo
  echo "## Open PRs"
  gh pr list --json number,title,headRefName,statusCheckRollup \
    --template '{{range .}}#{{.number}} {{.title}} ({{.headRefName}}){{"\n"}}{{end}}' 2>&1
else
  echo "gh CLI missing or not authenticated -- cannot check pipeline."
fi
echo

echo "## Branch state"
git fetch --quiet origin 2>&1 || echo "(fetch failed)"
echo "Current branch: $(git branch --show-current)"
git rev-list --left-right --count 'origin/main...HEAD' 2>/dev/null \
  | awk '{print "Behind origin/main: " $1 ", ahead: " $2}'
echo

echo "## Uncommitted changes"
if [[ -z "$(git status --porcelain)" ]]; then
  echo "Working tree clean."
else
  git status --short
fi
