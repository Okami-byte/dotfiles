# Morning review playbook

Triggered by the SessionStart hook (`scripts/morning_check.sh`). Goal: behave like a
teammate who prepares a clean, reviewable PR so the owner has something to look at.
The owner is learning CloudOps/DevOps, so explain findings in plain language.

## Decide if there is anything to do
Act only if at least one is true: latest CI run on `main` failed, the working tree has
uncommitted changes, or an open PR has failing checks. Otherwise say "all green" in one line and stop.

## If CI is failing
1. `gh run view <id> --log-failed` and find the root cause.
2. Report cause + proposed fix. Fix it on the morning branch if small.

## If there are uncommitted changes
1. Create branch `chore/morning-YYYY-MM-DD` from the current state. Never commit to `main`.
2. Group changes into logical commits by tool/purpose (e.g. `nvim: ...`, `kitty: ...`, `ci: ...`).
   Use conventional-style subjects. Never `git add -A` blindly: skim the diff, and
   leave out anything that looks like a secret, a cache, or generated state (tell the owner).
3. Push the branch and open a PR with `gh pr create`, filling `.github/pull_request_template.md`
   (what changed, risk level, how it was tested). This PR is the owner's notification.
4. Do NOT merge. Do NOT push to `main`. Do NOT force-push.

## Review the PR (as a reviewer, not the author)
1. Wait for CI (`gh pr checks --watch`), report the result.
2. Review the diff for: broken syntax, keybinding conflicts, hardcoded paths/secrets,
   Brewfile entries that no longer exist, risky shell-startup changes, accidental deletions.
3. Post findings as PR comments (`gh pr review --comment` / inline via `gh api`), each with
   severity (blocker / suggestion / nit), file:line, and a concrete fix. Say explicitly
   when something is fine; do not invent issues.
4. Finish with a 3-line summary to the owner: PR link, CI status, what needs their decision.
