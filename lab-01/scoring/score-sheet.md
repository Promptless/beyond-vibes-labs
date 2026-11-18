# Score sheet: pr146

You're the judge. Score your agent's patch against [the rubric](rubric-pr146.md), one criterion at a time, and quote the line from the patch behind each verdict. The DoGBench paper ran this step with an LLM judge; scoring it by hand shows you exactly why a patch earned its number.

Fill it in on paper, in a document, or in a copy of this file saved outside your `beyond-vibes-labs` folder.

## What you judge

You judge the patch: the changes shown on `my-patch.html`, which [step 5 of the lab](../README.md#5-open-your-agents-changes) opened in your browser. The page and the patch are saved in `~/beyond-vibes-lab-01/pr146`.

- **Score only Doc Detective's main README.** On `my-patch.html`, that's the section headed `README.md`, with no folder name in front of it. The rubric doesn't give credit for other files, though changes elsewhere can still introduce problems you tag later.
- **Anything not on the page is unchanged.** The page shows only the changed parts of each file. The rest of the README reads exactly as it did before the agent started.
- **Criteria about keeping existing content pass unless the patch removes or contradicts it.** C5 and C6 ask the patch to keep statements the README already makes. The criterion passes unless the patch removes that statement or adds text that contradicts it. Removed text appears struck through in red. If the statement doesn't appear on the page at all, the agent left it alone.
- **Read each criterion's Pass and Fail lines** in the rubric, not just its title.

## Before you start

- **Did your agent reply `NO_DOC_CHANGES_NEEDED`?** This task needs a docs change, so that decision is wrong and the score is **0**. Skip to the [tag sheet](../tags/tag-sheet.md).

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

For a fail, quote the line that contradicts the criterion, or name what's missing. For a C5 or C6 pass where the patch didn't touch the statement, write "unchanged".

## How each type counts

- **Requirement** (C1, C3–C6): always counted. Pass earns 1; fail earns 0.
- **Conditional** (C10): counted only when triggered, which happens when the patch adds or revises relevant material in the main `README.md`. If it isn't triggered, leave it out of both the earned and the counted totals.
- **Deduction-only** (C2): never earns credit and is never counted. If it's violated, subtract 1 from what the patch earned.
- **P0** (C1, C2): if C1 fails or C2 is violated, the score can't go above 60, however well the rest did.

## Work out the score

No script computes the score. You work it out by hand from your verdicts, in five steps. The [math section of the worked example](worked-example.md#the-math) shows these steps filled in for a published patch.

1. **Counted.** Start at 5, one for each requirement. Add 1 if C10 is triggered.
2. **Earned.** Count your passes among C1, C3, C4, C5, C6, and C10.
3. **C2 deduction.** If C2 is violated, subtract 1 from Earned. Don't go below 0.
4. **Uncapped score.** Divide Earned by Counted, then multiply by 100. Round to one decimal place. For example, 4 earned out of 6 counted is 66.7.
5. **Final score.** If C1 failed or C2 is violated, and the uncapped score is above 60, the final score is 60. Otherwise, the final score is the uncapped score.

| | |
| --- | --- |
| Counted | |
| Earned | |
| Earned after the C2 deduction | |
| Uncapped score | |
| C1 failed or C2 violated? (cap at 60) | |
| **Final score** | |

These steps match the scoring in DoGBench's [`dogbench/judge.py`](https://github.com/Promptless/dogbench/blob/main/dogbench/judge.py) (`numeric_score`), with every criterion weighted equally.

Next, tag the failure modes: [step 7 of the lab](../README.md#7-tag-the-failure-modes-5-minutes).
