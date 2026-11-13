<!--
Rubric for DoGBench item doc-detective-doc-detective-pr146, reproduced unmodified below this comment.
Source: promptless-research/dogbench-dev on Hugging Face, revision f8e5dd2040414810cc79e8f77167c84a12d76932, outcomes.jsonl.
SHA-256 of the rubric text: 32132e7424d6acdae7ee9c89e1fd9e72241b311f41c78dacebc7c1f660abdb12
License: CC BY-NC-ND 4.0. Cite DoGBench as shown in the repository README.
Open this file at the Score step, after your agent has finished.
-->

# Canonical public-example criteria revision

Evaluate English maintained documentation only. Ignore localized and translated content. Requirements are Pass/Fail; untriggered conditionals and clean deduction-only safeguards are neutral. No partial credit. Apply the canonical equal-criterion-weight scoring contract with a 60-point ceiling for active P0 failures. Each criterion owns the obligation named in its scope; do not penalize another criterion solely for the same omitted fact or defect. Concrete worked examples and explanatory prose can be distinct obligations when explicitly required.

### C1 — Document comma-separated multi-path input

**Priority:** P0 | **Category:** completeness | **Objectivity:** objective | **Scoring:** requirement

The maintained root `README.md` run/config guidance, or another equally discoverable location in the root README, must explicitly state that `--input` and its `-i` alias accept one or more file or directory paths, with multiple paths supplied as one comma-separated CLI value. Relevant surrounding wording must not contradict this behavior or frame the option exclusively as selecting one test file. Supporting contributor material, tests, fixtures, samples, generated references, navigation configuration, newly created documentation trees, source code, or dependency details may accompany the update but cannot substitute for the root-README guidance or present implementation internals as the public feature.

- **Pass:** The root README names both flags, clearly describes one comma-separated CLI value containing multiple file or directory paths, and does not leave contradictory exclusively single-file framing nearby.
- **Fail:** The behavior is absent from the root README; appears only on a supporting or implementation surface; omits the alias, multiple-path capability, or comma-separated representation; or nearby wording still presents `--input` exclusively as a single-file selector.

### C2 — Use only supported input representations

**Priority:** P0 | **Category:** safety | **Objectivity:** objective | **Scoring:** deduction_only

Apply these conditional accuracy safeguards:

- If the documentation shows or describes multiple CLI inputs, it must represent them as one comma-separated `--input` or `-i` string, not a JSON array or repeated flag.
- If the patch adds or changes `.doc-detective.json` input guidance, that guidance must accurately use JSON string-or-array semantics and must not present a comma-separated config string as multiple config inputs.
- If the patch discusses supported input protocols, it must not claim that HTTP or HTTPS inputs work.
- If the patch introduces other flags, schemas, precedence rules, or integration examples, those details must be supported rather than fabricated.

- **Not violated:** Neutral. No triggered safeguard is breached; safeguards whose subjects are not introduced or discussed remain neutral.
- **Violated:** At least one triggered safeguard is breached, including:
  - CLI syntax equivalent to `--input ["a.spec.json","b.spec.json"]`.
  - CLI syntax equivalent to `--input a.spec.json --input b.spec.json`.
  - `"input": "a.spec.json,b.spec.json"` presented as two config inputs.
  - Claims that URLs are passed through, used as-is, accepted, or can be mixed with local inputs.
  - Unsupported flags, schemas, precedence rules, or GitHub Action YAML.
- Evidence: base `src/utils.js:24-29`; PR-head `src/utils.js:93-105`; `doc-detective-common@3.0.3` config `stringOrArray` schema; package `resolvePaths.js:133-160` and the verified URL probe, which converted a URL array item into a local path.

### C3 — Give the reader an executable multi-input command

**Priority:** P1 | **Category:** completeness | **Objectivity:** objective | **Scoring:** requirement

The root README run/config guidance, or an equally discoverable root-README location, must include at least one copyable command that invokes `npx doc-detective` and uses a single `--input` or `-i` argument containing at least two realistic local paths, with one comma between adjacent paths.

- Pass example: `npx doc-detective --input input.spec.json,anotherInput.spec.json`.
- Pass with spaces: A quoted single value such as `npx doc-detective -i "input.spec.json, anotherInput.spec.json"`.
- Pass with more inputs: `npx doc-detective --input one.spec.json,two.spec.json,docs/`.
- Formatting: A language-tagged `bash` fence matches the local convention, but another equally clear and copyable Markdown command presentation passes.
- **Pass:** At least one command satisfies all of the invocation, single-argument, path-count, local-path, and comma-syntax requirements above.
- **Fail:** Only prose is added; every example still contains one path; repeated flags or array syntax are used; an unquoted space splits the intended value; or an example contains empty, doubled, leading, or trailing comma segments.
- Evidence: base README command pattern at `README.md:42-49,54-63`; PR-head `test/utils.test.js:132-146`; PR-head `src/utils.js:96`.

### C4 — Explain when the feature is useful

**Priority:** P1 | **Category:** purpose | **Objectivity:** objective | **Scoring:** requirement

Give a concise decision frame connecting the comma-separated form to selecting several specific files or directories in one CLI invocation. Overriding configured input without editing a config array, use in automation or GitHub Actions, or another equivalent use case may supply that frame. If integration-specific details are introduced, they must be accurate and interface-neutral.

- **Pass:** At least one clause explains when or why a reader would select multiple specific inputs through one command invocation, and any introduced integration details are supported.
- **Fail:** The documentation states only delimiter mechanics without indicating when or why a reader would use them, or it fabricates integration-specific configuration while supplying that explanation.

### C5 — Preserve the omitted-input default

**Priority:** P1 | **Category:** factual | **Objectivity:** objective | **Scoring:** requirement

Positive requirement: Retain the statement that omitting `--input` causes Doc Detective to scan the current directory.

Conditional safeguard: If new or revised prose discusses whether `--input` is required or describes the default input behavior, it must not imply that the flag is required.

- **Pass:** The existing default statement remains semantically intact, and any triggered safeguard is satisfied. An absent safeguard trigger imposes no additional condition.
- **Fail:** The default statement is removed or contradicted, or applicable prose implies that every invocation must specify input paths.
- Evidence: base `README.md:46`; base `src/utils.js:65-80`; PR-head `src/utils.js:81-105`.

### C6 — Preserve command-line precedence over configuration

**Priority:** P1 | **Category:** factual | **Objectivity:** objective | **Scoring:** requirement

Positive requirement: Retain the general rule that command-line arguments override `.doc-detective.json` values.

Conditional safeguard: If the patch revises the config-override example or otherwise discusses multi-input overriding, it must accurately allow one comma-separated CLI value to replace the configured input value.

- **Pass:** The general override statement remains semantically intact, and any changed override material is consistent with multi-input overriding. An absent safeguard trigger imposes no additional condition.
- **Fail:** Precedence is removed, reversed, or made ambiguous, or triggered override guidance inaccurately narrows the replacement to a single input.
- Evidence: base `README.md:52-64`; PR-head `test/utils.test.js:116-146`.

### C10 — Match README terminology and Markdown conventions

**Priority:** P2 | **Category:** style | **Objectivity:** subjective | **Scoring:** conditional

- **Trigger:** The patch adds or revises relevant material in the root README.
- **Not triggered:** Neutral. Exclude this criterion from earned and possible points.
- **Pass:** The triggered material follows the root README’s local conventions or uses an equally clear, readable, and copyable Markdown presentation. It uses the product name `Doc Detective`; presents flags, commands, filenames, and `.doc-detective.json` unambiguously; presents executable commands without shell prompts in a copyable command block; uses direct prose; accurately includes both files and directories; and has no material inconsistency that impairs readability, comprehension, or command copyability. Harmless wording or structural variation passes. Accurate nonessential implementation detail is permitted when it does not obscure the reader’s task, and correcting nearby pre-existing grammar or typographical defects is optional.
- **Fail:** A material inconsistency in the triggered material impairs readability, comprehension, or command copyability.
