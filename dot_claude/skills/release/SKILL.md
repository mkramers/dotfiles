---
name: release
description: Use when ready to cut a new release - collects changes, suggests version bump, and creates a GitHub release with notes
---

# Cut a Release

Generate release notes and create a tagged GitHub release from merged work since the last release.

## Process

1. **Get current version state:**
   ```bash
   git fetch --tags
   git describe --tags --abbrev=0 2>/dev/null || echo "no-tags"
   ```
   If no tags exist, this is the first release (v0.1.0).

2. **Collect changes since last release:**
   ```bash
   gh pr list --state merged --search "merged:>=<TAG_DATE>" --json number,title,mergedAt,body --limit 100
   ```
   To get the tag date:
   ```bash
   git log <TAG> -1 --format=%aI
   ```
   If first release, collect all merged PRs.

3. **Categorize and summarize:**
   Group PRs by conventional commit prefix from their titles:
   - `feat:` → Features
   - `fix:` → Bug Fixes
   - `chore:`, `refactor:`, `docs:`, etc. → Maintenance

   Write a brief high-level summary (2-3 sentences) of what this release includes.

4. **Suggest version bump:**
   Based on the conventional commit types found:
   - Any `feat:` → minor bump (v0.X.0 → v0.X+1.0)
   - Only `fix:`/`chore:` → patch bump (v0.X.Y → v0.X.Y+1)
   - If any PR mentions breaking changes → flag for user decision

   Present the suggestion. User confirms or overrides.

5. **Create release:**
   ```bash
   gh release create v<VERSION> \
     --title "v<VERSION>" \
     --generate-notes \
     --notes-start-tag <PREV_TAG> \
     --notes "<SUMMARY>"
   ```
   The `--notes` flag prepends the high-level summary above GitHub's auto-generated PR list.

6. **Post-release:**
   - Confirm the release was created
   - Show the release URL
   - Remind user to notify their colleague (Slack)

## First Release

If no tags exist:
- Default to v0.1.0
- Use `--generate-notes` without `--notes-start-tag` (GitHub will include everything)

## Categorized Release Notes

If the repo has `.github/release.yml`, GitHub auto-categorizes PRs by label. If it doesn't exist, suggest creating one:

```yaml
changelog:
  categories:
    - title: "Features"
      labels:
        - enhancement
    - title: "Bug Fixes"
      labels:
        - bug
    - title: "Other Changes"
      labels:
        - "*"
```

This is optional — the skill works fine without it by relying on Claude's summary + GitHub's flat PR list.

## Notes

- Always run from the main/default branch with a clean working tree.
- The skill suggests a bump but never creates a release without user confirmation.
- Release notes quality depends on PR descriptions — the `prepare` skill handles that upstream.
- For v0.x releases, minor bumps for features are standard (no major version pressure).
