# Tag sheet

Scoring tells you how far the patch got. Tagging tells you why it fell short. Do it in two passes:

1. **The patch.** Read your agent's changes on `my-patch.html` and mark every failure mode they show. One patch can show several, or none.
2. **The transcript.** Scroll back through what your agent did before it wrote, and mark the investigation patterns you see. [Step 7 of the lab](../README.md#7-tag-the-failure-modes-5-minutes) shows how to reopen it for your tool.

The DoGBench rate beside each tag is the share of the 1,267 submissions that DoGBench audited in which that problem appeared, so you can see whether your agent's failures are common or unusual.

## Patch failure modes

| Failure mode | What it looks like | DoGBench rate | In your patch? |
| --- | --- | --- | --- |
| Task-completion gap | Leaves out a decision point, procedure, verification step, or recovery path the reader needs. | 45.5% | |
| Technical inaccuracy | Misstates an interface or behavior, including its scope, default, lifecycle, or compatibility. | 36.6% | |
| Incomplete conceptual or reference coverage | Leaves out the core concept, capability, or contract the reader needs to understand and use the change. | 32.5% | |
| Missing supporting information | Covers the main task but leaves out rationale, boundaries, examples, or secondary cases. | 26.5% | |
| Missing prerequisites | Leaves out permissions, dependencies, credentials, versions, or other setup conditions. | 21.0% | |
| Information-architecture or findability failure | Puts content where readers won't look, or leaves out navigation, cross-references, and the terms readers search for. | 20.7% | |
| Missing audience and purpose framing | Doesn't establish who the content is for, why it matters, or when to use it. | 19.9% | |
| Cross-surface content inconsistency | Updates one page and leaves another page on the same topic out of date. | 13.3% | |
| Fabricated content | Invents a flag, setting, behavior, or example the product doesn't have. | 6.1% | |

## Investigation patterns

Look for these in the transcript, not the patch.

| Pattern | What to look for | DoGBench rate | In your transcript? |
| --- | --- | --- | --- |
| Described an interface without checking how readers use it | Read the implementation, then wrote about it without looking at the README's existing commands, examples, or flags. | 36.0% | |
| Missed decisive evidence and filled the gap with a plausible assumption | Stated something the code change doesn't establish, such as what happens to URL inputs, without tracing it. | 33.1% | |
| Edited the first plausible page and left other affected pages stale | Stopped at the first section that mentioned `--input` without checking for others. | 30.1% | |

## For pr146

The DoGBench rubric's two P0 criteria line up with two tags:

- Leaving out the `-i` alias, or presenting multiple inputs as files only, usually means **incomplete conceptual or reference coverage**.
- Claiming URL inputs work is a **technical inaccuracy**. When the transcript shows the agent never traced how inputs are resolved, add the **missed decisive evidence** pattern.

Next, post your results and compare: [step 8 of the lab](../README.md#8-post-your-results-and-compare-5-minutes).
