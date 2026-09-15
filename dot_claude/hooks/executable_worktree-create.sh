#!/bin/bash
# WorktreeCreate hook for Claude Code
# Creates worktrees at .claude/worktrees/<name> with branch name = worktree name (no prefix)
set -e

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r .name)
CWD=$(echo "$INPUT" | jq -r .cwd)
DIR="$CWD/.claude/worktrees/$NAME"

if [ -d "$DIR" ]; then
  echo "$DIR"
  exit 0
fi

git worktree add "$DIR" -b "$NAME" </dev/null >/dev/null 2>&1 || \
git worktree add "$DIR" "$NAME" </dev/null >/dev/null 2>&1 || \
{ echo "Failed to create worktree at $DIR" >&2; exit 1; }

echo "$DIR"
exit 0
