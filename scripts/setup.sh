#!/bin/bash
# Create a repo with one linked worktree, the layout agent runners typically use.
set -euo pipefail
rm -rf ~/app && git init -q ~/app && cd ~/app
echo "# app" > README.md && echo ".worktrees/" > .gitignore
git add . && git commit -qm "init"
git worktree add -q .worktrees/task-1 -b agent/task-1
mkdir -p .git/logs
echo "repo: ~/app   worktree: ~/app/.worktrees/task-1"
