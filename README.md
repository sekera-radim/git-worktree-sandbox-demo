# git worktree in a read-only sandbox

Why `git commit` fails with `read-only file system` inside a sandboxed git worktree, and the minimal fix.

    docker build -t wt-sandbox .
    docker run --rm --security-opt seccomp=unconfined --security-opt apparmor=unconfined wt-sandbox

The two `--security-opt` flags let bubblewrap create a user namespace inside the container.
