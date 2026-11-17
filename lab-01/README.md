# Lab #01: Score your agent's docs patch

**Wed Nov 18, 2026, 9:00–10:15 AM PT, online.**

You'll run one documentation task with the agent setup you use every day, score the patch it writes against a maintainer-validated rubric, and tag its failure modes. You leave with:

- your agent's scored patch
- a tally of its failure modes next to DoGBench's rates
- a [review checklist](checklist/review-checklist.md) for your agent's next docs PR
- this repository, so you can rerun the task after you change a prompt, a skill, or a model

## What this is, and what it isn't

The task is `doc-detective-doc-detective-pr146` from DoGBench's public dev split. It comes from a real pull request that lets Doc Detective's `--input` option take several comma-separated paths, and the job is to update the README to match. The rubric was validated by the project's maintainer.

Your score is **one run of one task, judged by you**. It isn't a DoGBench score and doesn't rank your agent against the leaderboard. DoGBench runs 292 tasks and uses an LLM judge. What one task gives you is a concrete, explainable look at where your setup succeeds and fails.

Don't open anything in `scoring/` until your agent finishes. Don't open this task's page on dogbench.ai or `scoring/worked-example.md` until you've scored your patch: both show the published verdicts.

## Before the lab (10 minutes)

You need:

- **Git**
- **The agent you use day to day**, installed and signed in: Claude Code, Codex, Copilot, Cursor, OpenCode, or another
- **Your usual setup**: your user-level instructions, skills, and model settings. Testing your setup is the point.

Then clone this repository and build the task workspaces:

```bash
git clone https://github.com/Promptless/beyond-vibes-labs.git
cd beyond-vibes-labs
```

**macOS, Linux, or WSL:**

```bash
lab-01/setup.sh
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1
```

Or run `lab-01/setup.sh` from Git Bash, which comes with Git for Windows. The PowerShell script runs the same script through Git Bash.

Setup takes under a minute and needs only Git and a network connection. It creates `~/lab-01-tasks` (on Windows, `%USERPROFILE%\lab-01-tasks`) with one folder per task:

```
~/lab-01-tasks/
├── pr146/
│   ├── docs/      Doc Detective's repository before the change. Your agent works here.
│   ├── code/      The same repository with the code change as its latest commit. Read it; don't edit it.
│   └── TASK.md    The prompt you'll paste into your agent.
└── common-pr65/   The stretch task, with the same layout.
```

When setup finishes, it prints the pr146 prompt between a `copy from the next line` marker and a `copy to the line above` marker. That's the text you'll paste into your agent.

The workspaces sit outside this repository so your agent can't read the rubric or the worked example while it works. Upstream history and remotes are removed, so the agent can't see how the maintainer actually documented the change.

## During the lab

Manny works the task on screen first, from setup to tags. Then you do each step yourself.

### 1. Run (10 minutes)

1. Start a **new** session of your agent in `~/lab-01-tasks/pr146/docs`. See [Agent notes](#agent-notes) for how to do that and how to turn off web access in your tool.
2. Paste the prompt setup printed, everything between the two copy markers, as your first message. If it has scrolled away, it's also in `~/lab-01-tasks/pr146/TASK.md`.
3. Let it run once. Don't steer it or ask for a second draft. If it asks a question, answer "use your judgment". Approve file edits in `docs/` and reads of `../code/` if your tool asks.

When it finishes, save its work:

```bash
cd ~/lab-01-tasks/pr146
git -C docs diff > my-patch.diff
```

`git diff` leaves out new files, so also run `git -C docs status --short` to list any the agent created. Save the agent's final message to `my-reply.md` in the same folder, and keep the session or transcript open for the tag step.

If your agent replied `NO_DOC_CHANGES_NEEDED`, that's its decision. Save the reply and move on.

### 2. Score (10 minutes)

Open [the score sheet](scoring/score-sheet.md) and [the rubric](scoring/rubric-pr146.md). Give each criterion a verdict, quoting the line from your patch behind it. If C1 fails or C2 is violated, the score can't go above 60.

### 3. Tag (5 minutes)

Use [the tag sheet](tags/tag-sheet.md) to mark the failure modes in your patch, then the investigation patterns in your agent's transcript. If you finish early, start the [stretch task](stretch/README.md).

### 4. Compare (5 minutes)

Post your score, tags, and tool and model to the room's results sheet, which is linked in the session chat. Then read [the worked example](scoring/worked-example.md), which scores the only published patch that passed C1, line by line.

### 5. Clinic (15 minutes, not recorded)

Bring questions about your own setup: instructions, skills, models, and review habits.

## Agent notes

The prompt in `TASK.md` is DoGBench's frozen prompt for this task, unchanged except for two edits:

- The code path is `../code` instead of `/task/code_repo`.
- One closing line asks the agent not to browse the web.

The agents in the DoGBench paper ran without network access. Turning web access off in your tool keeps your run comparable, and stops the agent from looking up the merged pull request.

Your user-level instructions and skills load as usual. Project-level files from your own repositories (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, and so on) don't, because the agent is working in Doc Detective's repository. To test one, copy it into `pr146/docs` before you start, and say so on the results sheet.

Full runs of this task with Claude Code and with Codex CLI each took under a minute, using the commands below. The notes for the other tools come from each tool's documentation, checked on Nov 13, 2026.

#### Claude Code

```bash
cd ~/lab-01-tasks/pr146/docs
claude --add-dir ../code --disallowedTools WebFetch WebSearch
```

`--add-dir ../code` lets Claude Code read the code change without asking for each file. `--disallowedTools` removes the web tools for this session. ([CLI reference](https://code.claude.com/docs/en/cli-reference), [permissions](https://code.claude.com/docs/en/permissions))

#### Codex CLI

```bash
codex --cd ~/lab-01-tasks/pr146/docs --sandbox workspace-write -c web_search='"disabled"'
```

The `workspace-write` sandbox limits edits to `docs/` and turns network access off. Codex can still read `../code`. `web_search="disabled"` turns off Codex's built-in web search, which otherwise defaults to a cached index. Don't pass `--search`. ([sandboxing](https://learn.chatgpt.com/docs/sandboxing), [config reference](https://learn.chatgpt.com/docs/config-file/config-reference))

#### GitHub Copilot CLI

```bash
copilot -C ~/lab-01-tasks/pr146/docs --add-dir=../code --deny-tool='url'
```

`--add-dir=../code` grants access to the code change. `--deny-tool='url'` blocks URL access through web fetch and the shell. ([command reference](https://docs.github.com/en/copilot/reference/cli-command-reference))

#### Cursor

- **Editor:** open `~/lab-01-tasks/pr146/docs` as the folder, then start a new Agent chat.
- **CLI:** run `agent --workspace ~/lab-01-tasks/pr146/docs`.

Cursor reads files outside the workspace, including `../code`, without asking by default. Its docs don't describe a switch that turns off the web search tool. To hold web fetches for your approval, set **Settings > Agents > Approvals & Execution** to **Allowlist**, and decline any web request the agent makes. ([agent security](https://cursor.com/docs/agent/security), [CLI permissions](https://cursor.com/docs/cli/reference/permissions))

#### OpenCode

```bash
opencode ~/lab-01-tasks/pr146/docs
```

Before you start, create `opencode.jsonc` in `docs/` to turn off web fetch and web search. OpenCode 2 uses this form:

```jsonc
{
  "permissions": [
    { "action": "webfetch", "resource": "*", "effect": "deny" },
    { "action": "websearch", "resource": "*", "effect": "deny" }
  ]
}
```

OpenCode 1 uses `{ "permission": { "webfetch": "deny", "websearch": "deny" } }`, and asks before it reads `../code`. Approve that read when it asks. ([permissions](https://opencode.ai/docs/permissions/), [migrating from v1](https://opencode.ai/docs/migrate-v1/))

#### Any other agent

Start it in `~/lab-01-tasks/pr146/docs`, let it read `../code`, and turn off web access if the tool allows it. If it can't be turned off, note that on the results sheet.

## After the lab

To rerun the task after changing your setup, rebuild a clean workspace from your `beyond-vibes-labs` clone and run it again:

```bash
lab-01/setup.sh --force pr146
```

In PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1 --force pr146
```

`--force` deletes the old workspace, including your saved patch, so move `my-patch.diff` and `my-reply.md` somewhere else first.

Bring the [review checklist](checklist/review-checklist.md) to your agent's next docs PR.

## Credits

- The task, the rubric, and the frozen prompt come from [DoGBench](https://dogbench.ai) ([code](https://github.com/Promptless/dogbench), [dev split](https://huggingface.co/datasets/promptless-research/dogbench-dev)).
- The code change is [doc-detective/doc-detective#146](https://github.com/doc-detective/doc-detective/pull/146). The stretch task's code change is [doc-detective/common#65](https://github.com/doc-detective/common/pull/65). Doc Detective is AGPL-3.0, and setup downloads it from GitHub rather than copying it into this repository.
- [LICENSE-CONTENT.md](../LICENSE-CONTENT.md) lists which license applies to each file.
