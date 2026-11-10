#!/bin/bash
# Usage: sandbox.sh <strict|fixed> <command...>
# strict: only the worktree is writable.
# fixed:  worktree + the parts of the main .git that a linked worktree writes to.
set -euo pipefail
mode=$1; shift
repo=~/app; name=task-1; wt=$repo/.worktrees/$name; g=$repo/.git
args=(--unshare-user --ro-bind / / --dev /dev --proc /proc --tmpfs /tmp --bind "$wt" "$wt")
if [ "$mode" = fixed ]; then
  for d in objects refs logs "worktrees/$name"; do args+=(--bind "$g/$d" "$g/$d"); done
fi
exec bwrap "${args[@]}" --chdir "$wt" -- "$@"
