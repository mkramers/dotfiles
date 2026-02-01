# Principles

- YAGNI. Do not over-engineer, gold-plate, or anticipate future requirements. Build what is needed now.
- Keep solutions simple and minimal. Prefer the obvious approach over the clever one.
- Bias toward action on implementation details. Ask before making architectural or design decisions.

# Git & Workflow

- Use conventional commit messages (feat:, fix:, chore:, etc.).
- Do NOT include co-authorship attributions (Co-Authored-By) in commits, PR descriptions, or any git metadata. Ever.
- Generally commit your work, but when in doubt, ask.
- Always work on feature branches. Create PRs for review. Do not push directly to main/master without explicit confirmation.
- Git worktrees may be in use — be aware of the working directory context. Before you start to create a worktree, check if you are already in one. When in doubt ask

# Code Style

- Follow whatever linters, formatters, and conventions the repo already has configured.
- Variable and function names should be complete words, concise, and understandable by someone unfamiliar with the codebase.
- Only add code comments when:
  - The purpose of a block of code is not obvious.
  - We are deviating from the standard or obvious approach.
  - There are caveats or foot-guns that cannot be eliminated through code structure or the type system.
- Never add a comment that restates a function or variable name.

# Testing

- Python: pytest
- TypeScript: jest
- Prefer writing tests for meaningful behavior, not for coverage.

# Tooling

- Use `just` for repo-wide commands (fmt, lint, test, run, etc.). Suggest adding a justfile if one doesn't exist. Keep it lean — don't bloat it.
