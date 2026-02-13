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

## Process

1. Run git log for each repo with author filter:
   ```bash
   cd <repo> && git log --oneline --since="last saturday" --author="<authors>" --all
   ```

2. Analyze commits across all repos for themes

3. Generate 4-6 bullet points with:
   - Scientific/engineering language appropriate for SR&ED
   - Focus on research, experimentation, technical uncertainty, systematic investigation
   - Emphasize architectural decisions, algorithm development, system design
   - Keep each bullet brief but substantive

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

- [Bullet 1: describe engineering/research work]
- [Bullet 2: ...]
- [Bullet 3: ...]
- [Bullet 4: ...]
- [Bullet 5: optional]
- [Bullet 6: optional]
```

## Notes

- Review commits with user if any bullet needs clarification on scope
- Don't embellish - accurately represent the work in SR&ED-appropriate language
- Group related commits into single bullets where appropriate
