# Worked example: a published pr146 patch, scored

Read the verdicts after you've scored your own patch, so they don't shape yours. [The math](#the-math) shows how to work out a score from verdicts, and you can use it as a model for your own arithmetic at any time.

This is the Promptless agent's patch for pr146, as published on [dogbench.ai](https://dogbench.ai) with DoGBench's judge verdicts. It scored 60, the top score among the 10 published patches, and it's the only one that passed C1. None of them was mergeable.

## The patch

An excerpt of the patch to Doc Detective's main `README.md`. Lines starting with `+` are the ones the agent added; the other lines were already there:

```diff
 npx doc-detective --input doc-content-inline-tests.md
 ```
 
+To run tests from several files or directories in one run, pass a comma-separated list to `--input` (or its alias, `-i`). Doc Detective resolves each local path relative to the current working directory and leaves `http://` and `https://` URLs as they are. For example, to run tests in `doc-content-inline-tests.md` and `tests.spec.json`, run the following command:
+
+```bash
+npx doc-detective --input doc-content-inline-tests.md,tests.spec.json
+```
+
```

## Criterion by criterion

| ID | Verdict | Quote | Why |
| --- | --- | --- | --- |
| C1 (P0) | Pass | "pass a comma-separated list to `--input` (or its alias, `-i`)" | Names both flags and describes one comma-separated value holding several files or directories. |
| C2 (P0) | **Violated** | "leaves `http://` and `https://` URLs as they are" | Claims URL inputs pass through. The code change skips path resolution for URLs, but the shared library still turns them into local paths, so URL inputs don't work. |
| C3 | Pass | `npx doc-detective --input doc-content-inline-tests.md,tests.spec.json` | One `--input` value, two realistic local paths, one comma. |
| C4 | Pass | "To run tests from several files or directories in one run" | Says when you'd use the feature, not only how. |
| C5 | Pass | (unchanged) "By default, Doc Detective scans the current directory…" | The patch doesn't remove or contradict the default statement, so it's intact. |
| C6 | Pass | (unchanged) | The patch doesn't touch the rule that command-line arguments override `.doc-detective.json`, so it's intact. |
| C10 | Fail (triggered) | "leaves `http://` and `https://` URLs as they are" | The patch revises the main README, which triggers C10, and its new guidance contains a material inaccuracy. |

## The math

- Counted: 5 requirements + C10 (triggered) = **6**
- Earned: C1, C3, C4, C5, C6 = **5**
- C2 violated: 5 − 1 = **4**
- Uncapped: 100 × 4 ÷ 6 = **66.7**
- P0 failed (C2), so the cap applies: **60**

## What the other nine did

Every published patch violated C2. The other nine also failed C1 because they left out the `-i` alias, which put a P0 failure on both criteria. That group includes all seven agents in the DoGBench paper, whose patches scored 50 or 60. The item's page on dogbench.ai shows every patch and verdict.

## Why the URL trap catches so many agents

Part of the task context in `~/beyond-vibes-lab-01/pr146/TASK.md` reads: ``Entries beginning with ` or ` are left unmodified.`` That sentence originally named `http://` and `https://`, and those strings were lost when the item was prepared. The paper agents saw the same text, so the lab prompt keeps it unchanged. An agent that read `~/beyond-vibes-lab-01/pr146/code/src/utils.js` found the `// Don't resolve URLs` branch and could easily conclude that URLs are supported. Proving otherwise meant following the input into the shared library, which the code change doesn't show.
