# Principles

- YAGNI. Do not over-engineer, gold-plate, or anticipate future requirements. Build what is needed now.
- Keep solutions simple and minimal. Prefer the obvious approach over the clever one.
- Bias toward action on implementation details. Ask before making architectural or design decisions.
- When in doubt, ask. If unsure about intent, approach, or a non-obvious assumption — stop and ask rather than guessing. A wrong guess costs more than a quick question.

# Communication

Optimize for skimming. I read across several agents at once and skim by default.

- Lead with the answer. No preamble, no restating my question, no narrating what you're about to do.
- Default under ~150 words — I ask probing questions, so let me pull detail rather than front-load it. Expand when I ask or the task needs it.
- Cut filler. Short sentences. If a word can be dropped, drop it.
- State findings, not process. Don't narrate what you're about to check or interpret tool output at length — give the conclusion, cite the evidence in a clause.
- Bullets for lists, tables for comparisons, prose only for genuinely connected reasoning. One idea per bullet.
- Front-load the keyword in each bullet so the left edge scans. Bold only the load-bearing term, never whole sentences.
- No closing recap. Don't re-summarize an answer that was already a list.
- Keep real caveats, but compress them to a line at the end rather than weaving them through.

# Git & Workflow

- Use conventional commit messages (feat:, fix:, chore:, etc.).
- Do NOT include co-authorship attributions (Co-Authored-By) in commits, PRs, PR descriptions, or any git metadata. Ever.
- Always commit your work. Do not leave unstaged/uncommitted changes — the user reviews via branch diffs (PyCharm, `gdd`), which only see committed state. WIP commits are fine; they'll be squashed on merge.
- Always work on feature branches; create PRs for review. Do not push to main/master without explicit confirmation. Exception: dotfiles/config repos (e.g. chezmoi) — commit straight to `main`, no branch or PR.
- Git worktrees are available but not the default — use `wt switch` (`wts`) when isolation is needed; don't assume worktrees unless asked.
- Branch names start with the ticket ID (e.g., `ALT-123-some-feature`). Do not add directory prefixes.
- Do not commit plans to code repos. Plans live at `../plans/<project-name>/`; each repo's `docs/plans/` is a symlink there. New worktrees get the symlink via worktrunk hook; for a primary worktree, create it once:
  ```sh
  mkdir -p ../plans/$(basename $(git rev-parse --show-toplevel)) docs
  ln -sf $(realpath ../plans/$(basename $(git rev-parse --show-toplevel))) docs/plans
  ```

# Code Style

- Follow whatever linters, formatters, and conventions the repo already has configured.
- Python: put imports at the top of the file (PEP 8). Do not use function-local imports unless there is a concrete reason (circular import, optional dependency).
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

- Use `just` for repo-wide commands (fmt, lint, test, run, etc.). Suggest adding a justfile if one doesn't exist. Keep it lean — don't bloat it. Give new justfiles a hidden default recipe (`_default:` running `@just --list`).
- Always use `uv` for Python (package management, venvs, running scripts).
- Use `mise` for projects that need their own tool binaries (e.g., pods, node, etc.).
- Python CLIs: use `typer` + `rich`.
