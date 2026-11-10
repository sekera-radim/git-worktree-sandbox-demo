#!/bin/bash
set -uo pipefail
cd ~ && bash scripts/setup.sh >/dev/null
fail() { echo "FAIL: $1"; exit 1; }
out=$(bash scripts/sandbox.sh strict bash -c 'echo work > feature.txt && git add feature.txt' 2>&1) && fail "strict commit should fail"
echo "$out" | grep -qi "read-only file system" || fail "expected read-only error, got: $out"
echo "ok 1 - strict sandbox reproduces the read-only error"
bash scripts/sandbox.sh strict bash -c 'test -f feature.txt' || fail "worktree should be writable"
echo "ok 2 - the worktree itself is writable"
bash scripts/sandbox.sh fixed bash -c 'git add feature.txt && git commit -qm "agent work"' || fail "fixed commit should pass"
git -C ~/app log --oneline agent/task-1 | grep -q "agent work" || fail "commit not visible from main clone"
git -C ~/app fsck --no-dangling >/dev/null 2>&1 || fail "repository is not consistent after sandboxed commit"
echo "ok 3 - fixed sandbox commits, main clone sees the commit, fsck is clean"
bash scripts/sandbox.sh fixed bash -c 'echo x > ~/app/README.md' 2>/dev/null && fail "main tree must stay read-only"
bash scripts/sandbox.sh fixed bash -c 'echo x > ~/app/.git/config' 2>/dev/null && fail ".git/config must stay read-only"
echo "ok 4 - main working tree and .git/config stay read-only"
echo "ALL PASSED"
