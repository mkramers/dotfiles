---
name: sred-summary
description: Use when generating weekly SR&ED tax credit summaries, reviewing recent commits for scientific research reporting, or when user asks for /sred
---

# SR&ED Weekly Summary

Generate bullet points summarizing engineering work for SR&ED (Scientific Research and Experimental Development) tax credit reporting.

## Configuration

```yaml
repos:
  - /Users/mk/altis/nota
  - /Users/mk/altis/ml-serve
  - /Users/mk/altis/altis-labs-ml-ops
  - /Users/mk/altis/nifti-viewer
  - /Users/mk/altis/dicom-crawler

authors: "Matt\\|mkramers\\|matt@altislabs\\|mattkramers"

date_range: "last Saturday to today"
```

## History

A history file at `~/.claude/skills/sred-summary/history.md` tracks previous summaries. Before generating bullets:

1. Read `history.md` to see what was reported in prior weeks
2. If this week's commits continue work from a previous summary, use continuation language:
   - "Continued development of...", "Advanced the...", "Iterated on...", "Extended the..."
   - Do NOT present ongoing multi-week work as if it were new
3. After the user accepts the summary, append it to `history.md`

## Process

1. Read `~/.claude/skills/sred-summary/history.md` (create if missing)

2. Run git log for each repo with author filter:
   ```bash
   cd <repo> && git log --oneline --since="last saturday" --author="<authors>" --all
   ```

3. Cross-reference commits against history to identify new vs. continuing work

4. Generate 4-6 bullet points, split into two buckets:
   - **Bucket A (~60%):** The larger share of effort this week
   - **Bucket B (~40%):** The smaller share
   - Scientific/engineering language appropriate for SR&ED
   - Focus on research, experimentation, technical uncertainty, systematic investigation
   - Emphasize architectural decisions, algorithm development, system design
   - Keep each bullet brief but substantive
   - Use continuation language for work that spans multiple weeks

## SR&ED Language Guidelines

**Use terms like:**
- "Engineered", "Designed", "Developed", "Implemented"
- "Architecture", "Framework", "Abstraction layer"
- "Fault tolerance", "High availability", "Disaster recovery"
- "Systematic", "Automated", "Distributed"

**Frame work as:**
- Solving technical uncertainties
- Experimental development
- Technological advancement
- Novel solutions to engineering challenges

## Output Format

```
**Week of [date range]**

**Bucket A (60%)**
- [Bullet 1]
- [Bullet 2]
- [Bullet 3]

**Bucket B (40%)**
- [Bullet 1]
- [Bullet 2]
```

## Notes

- Review commits with user if any bullet needs clarification on scope
- Don't embellish - accurately represent the work in SR&ED-appropriate language
- Group related commits into single bullets where appropriate
- The 60/40 split is approximate — use judgement based on commit volume and effort
