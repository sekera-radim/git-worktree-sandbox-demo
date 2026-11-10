#!/bin/bash
# List worktrees that hold uncommitted work (what a failed sandboxed commit leaves behind).
for wt in ~/app/.worktrees/*/; do
  n=$(git -C "$wt" status --porcelain | wc -l)
  echo "$n uncommitted  $wt"
done
