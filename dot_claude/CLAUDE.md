# Principles

- YAGNI. Do not over-engineer, gold-plate, or anticipate future requirements. Build what is needed now.
- Keep solutions simple and minimal. Prefer the obvious approach over the clever one.
- Bias toward action on implementation details. Ask before making architectural or design decisions.

# Git & Workflow

- Use conventional commit messages (feat:, fix:, chore:, etc.).
- Do NOT include co-authorship attributions (Co-Authored-By) in commits, PRs, PR descriptions, or any git metadata. Ever.
- Always commit your work. Do not leave unstaged/uncommitted changes — the user reviews via branch diffs (PyCharm, `gdd`), which only see committed state. WIP commits are fine; they'll be squashed on merge.
- Always work on feature branches. Create PRs for review. Do not push directly to main/master without explicit confirmation.
- Git worktrees are the standard workflow. Each task/branch gets its own worktree; the main repo directory stays on the default branch and is not used for development. Before creating a worktree, check if you are already in one. Use `wt switch` (`wts`) to create/switch worktrees.
- Do not commit plans to code repos. Plans live in a separate repo at `../plans/<project-name>/` relative to the current repo. Write plans there (e.g., `../plans/myproject/some-feature.md`). The `docs/plans/` directory in each repo is a symlink to this location. New worktrees get the symlink automatically via worktrunk hook. For the primary worktree, set it up once:
  ```sh
  mkdir -p ../plans/$(basename $(git rev-parse --show-toplevel)) docs
  ln -sf $(realpath ../plans/$(basename $(git rev-parse --show-toplevel))) docs/plans
  # if docs/plans already exists as a real dir, move it first:
  # mv docs/plans docs/plans-old && ln -sf ... && mv docs/plans-old/* ../plans/<name>/ && rmdir docs/plans-old
  ```

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
- Always use `uv` for Python (package management, venvs, running scripts).
- Use `mise` for projects that need their own tool binaries (e.g., pods, node, etc.).
- Python CLIs: use `typer` + `rich`.
