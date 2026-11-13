# Score sheet: pr146

You're the judge. Score your agent's patch against [the rubric](rubric-pr146.md), one criterion at a time, and quote the line from the patch behind each verdict. The DoGBench paper ran this step with an LLM judge; scoring it by hand shows you exactly why a patch earned its number.

Copy this file somewhere outside the repository (or print it) and fill it in.

## Before you start

- **Did your agent reply `NO_DOC_CHANGES_NEEDED`?** This task needs a docs change, so that decision is wrong and the score is **0**. Skip to the tag sheet.
- **Did your agent edit files outside `README.md`?** Score only the root `README.md`. The rubric doesn't give credit for other files, though changes elsewhere can still introduce problems you tag later.
- Read each criterion's **Pass** and **Fail** lines in the rubric, not just its title.

## The sheet

| ID | Criterion | Priority | Type | Your verdict | Quote from the patch |
| --- | --- | --- | --- | --- | --- |
| C1 | Document comma-separated multi-path input | P0 | Requirement | Pass / Fail | |
| C2 | Use only supported input representations | P0 | Deduction-only | Violated / Not violated | |
| C3 | Give the reader an executable multi-input command | P1 | Requirement | Pass / Fail | |
| C4 | Explain when the feature is useful | P1 | Requirement | Pass / Fail | |
| C5 | Preserve the omitted-input default | P1 | Requirement | Pass / Fail | |
| C6 | Preserve command-line precedence over configuration | P1 | Requirement | Pass / Fail | |
| C10 | Match README terminology and Markdown conventions | P2 | Conditional | Not triggered / Pass / Fail | |

For a fail, quote the line that contradicts the criterion, or name what's missing.

## How each type counts

- **Requirement** (C1, C3–C6): always counted. Pass earns 1; fail earns 0.
- **Conditional** (C10): counted only when triggered, which happens when the patch adds or revises relevant material in the root `README.md`. If it isn't triggered, leave it out of both the earned and the counted totals.
- **Deduction-only** (C2): never earns credit and is never counted. If it's violated, subtract 1 from what the patch earned.
- **P0** (C1, C2): if C1 fails or C2 is violated, the score can't go above 60, however well the rest did.

## The math

```
counted  = requirements (5) + C10 if triggered (1)
earned   = passed requirements + passed C10
adjusted = earned − 1 if C2 is violated, otherwise earned (never below 0)
score    = 100 × adjusted ÷ counted
if C1 failed or C2 violated: score = min(score, 60)
```

| | |
| --- | --- |
| Counted | |
| Earned | |
| C2 violated? (−1) | |
| Uncapped score | |
| P0 failed? (cap at 60) | |
| **Final score** | |

[The worked example](worked-example.md) scores a published patch line by line. Open it after you've scored your own, so it doesn't shape your verdicts.

This formula is the one in DoGBench's [`dogbench/judge.py`](https://github.com/Promptless/dogbench/blob/main/dogbench/judge.py) (`numeric_score`), with every criterion weighted equally.
