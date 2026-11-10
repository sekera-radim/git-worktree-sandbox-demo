#!/bin/bash
# A task that spans two repositories: the sandbox fix was applied to ~/app only.
# Usage: second-repo.sh <app-only|both>
set -euo pipefail
mode=${1:-app-only}
if [ ! -d ~/lib ]; then
  git init -q ~/lib && cd ~/lib && echo "# lib" > README.md && echo ".worktrees/" > .gitignore
  git add . && git commit -qm "init" && git worktree add -q .worktrees/task-1 -b agent/task-1 && mkdir -p .git/logs
fi
args=(--unshare-user --ro-bind / / --dev /dev --proc /proc --tmpfs /tmp)
repos=(app); [ "$mode" = both ] && repos=(app lib)
for r in app lib; do args+=(--bind ~/$r/.worktrees/task-1 ~/$r/.worktrees/task-1); done
for r in "${repos[@]}"; do
  for d in objects refs logs worktrees/task-1; do args+=(--bind ~/$r/.git/$d ~/$r/.git/$d); done
done
exec bwrap "${args[@]}" --chdir ~/lib/.worktrees/task-1 -- bash -c 'echo change > lib.txt && git add lib.txt && git commit -qm "lib change" && echo "committed in lib"'
