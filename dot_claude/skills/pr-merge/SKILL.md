---
name: pr-merge
description: Use when the user wants to squash merge a PR from the CLI, crafting a good conventional commit message from the PR content
---

# PR Squash Merge

Squash merge the current branch's PR with a well-crafted conventional commit message.

## Process

1. Get the current branch's PR:
   ```bash
   gh pr view --json number,title,body,commits,baseRefName
   ```

2. Review the diff against base:
   ```bash
   gh pr diff
   ```

3. Craft the squash merge commit message:
   - **Title**: single conventional commit line for the primary change (`feat:`, `fix:`, `chore:`, etc.)
   - **Body**: if the PR covers multiple distinct changes, list each as a separate conventional commit line
   - Keep it concise — summarize the work, don't repeat every commit verbatim

4. Present the commit message to the user for approval

5. Merge:
   ```bash
   gh pr merge --squash --subject "<title>" --body "<body>"
   ```

## Commit Message Format

Single-focus PR:
```
feat: Add JSON fold counts plugin for Sublime Text
```

Multi-focus PR:
```
feat: Add user authentication system

feat: Add JWT token validation middleware
fix: Handle expired token edge case in refresh flow
chore: Update auth dependency to v2.3
```

## Notes

- Always present the message for user approval before merging
- Use the diff and commits to understand the work — don't just parrot PR title/body
- If the PR has no associated branch or is already merged, inform the user
