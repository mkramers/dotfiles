---
name: prepare
description: Use when a branch is ready for PR - reviews code, assesses risk, and creates a PR with full context and risk assessment
---

# Prepare Branch for PR

Review the current branch, assess risk, and create a well-documented PR.

## Process

1. **Gather context:**
   ```bash
   git rev-parse --abbrev-ref HEAD
   git log main..HEAD --oneline
   git diff main...HEAD --stat
   ```
   Also read the full diff for review.

2. **Structured code review:**
   Review the full diff for:
   - Correctness and edge cases
   - Security concerns
   - Missing tests or test gaps
   - Anything that smells off

   Note findings — these go into the PR comment.

3. **Risk assessment:**
   Load `.claude/prepare.yml` from the project root if it exists. Evaluate three signals:

   - **Operational impact:** Do any changed files match `operational_paths` patterns? Would this change affect how an operator uses the system?
   - **Diff size:** Total lines changed. Compare against `large_diff_threshold` (default: 300).
   - **Codebase area:** Do changed files match `core_paths` patterns?

   Determine tier:
   - **Self-merge** — small diff AND no operational impact AND not core. Safe to merge after reading the review.
   - **Needs review** — any of: operational impact, large diff, or core path changes. Schedule review with a colleague.

   If no config file exists, default to **needs review** for everything (safe default until configured).

4. **Create PR:**
   Generate a PR title in conventional commit format and a description covering:
   - **What** changed (brief summary)
   - **Why** (motivation, ticket/context if available)
   - **How** (approach, key decisions)
   - **Testing** (what was tested, how to verify)

   ```bash
   gh pr create --title "<title>" --body "<description>"
   ```

5. **Add risk assessment comment:**
   Post a PR comment with:
   - Risk tier (self-merge or needs-review) and reasoning
   - Review findings (concerns, suggestions, positive notes)
   - If operational impact detected: flag which docs/runbook sections may need updating

   ```bash
   gh pr comment --body "<assessment>"
   ```

6. **Present summary to user:**
   Show the PR link, risk tier, and recommended next action:
   - Self-merge → "Looks good to self-merge. Run `/pr-merge` when ready."
   - Needs review → "Flagged for review. Schedule time with your colleague."

## Risk Config Format

Per-project file at `.claude/prepare.yml`:

```yaml
core_paths:
  - src/pipeline/
  - src/models/

operational_paths:
  - config/
  - scripts/run_pipeline.sh
  - Dockerfile

large_diff_threshold: 300
```

Path patterns are prefix-matched against changed file paths. If a changed file starts with any pattern, it's a match.

## Notes

- The review step is your rubber duck — read the findings even for self-merge PRs.
- Risk assessment is a recommendation, not a gate. You decide what to do.
- If the branch already has a PR, update it instead of creating a new one.
- Always run from the feature branch, not main.
