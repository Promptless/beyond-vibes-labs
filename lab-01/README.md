# Lab #01: Score your agent's docs patch

**Wed Nov 18, 2026, 9:00–10:15 AM PT, online.**

You'll run one documentation task with the agent setup you use every day, score the patch it writes against a maintainer-validated rubric, and tag its failure modes. You leave with:

- your agent's scored patch
- a tally of its failure modes next to DoGBench's rates
- a [review checklist](checklist/review-checklist.md) for your agent's next docs PR
- this repository, so you can rerun the task after you change a prompt, a skill, or a model

## What this is, and what it isn't

The task is `doc-detective-doc-detective-pr146` from DoGBench's public dev split. It comes from a real pull request, Doc Detective pull request #146, that lets Doc Detective's `--input` option take several comma-separated paths. The job is to update Doc Detective's README to match. The rubric was validated by the project's maintainer.

Your score is **one run of one task, judged by you**. It isn't a DoGBench score and doesn't rank your agent against the leaderboard. DoGBench runs 292 tasks and uses an LLM judge. What one task gives you is a concrete, explainable look at where your setup succeeds and fails.

## Follow along in a browser

If you can't install or run anything, for example on a locked-down work laptop, you can still do the scoring half of the lab in your browser:

1. Watch Manny run the task on screen and open his agent's changes.
2. Score that patch with the [score sheet](https://github.com/Promptless/beyond-vibes-labs/blob/main/lab-01/scoring/score-sheet.md) and the [rubric](https://github.com/Promptless/beyond-vibes-labs/blob/main/lab-01/scoring/rubric-pr146.md).
3. Tag it with the [tag sheet](https://github.com/Promptless/beyond-vibes-labs/blob/main/lab-01/tags/tag-sheet.md).
4. Compare your verdicts with the [worked example](https://github.com/Promptless/beyond-vibes-labs/blob/main/lab-01/scoring/worked-example.md), which scores a published patch for the same task.

## The folders you'll use

The lab uses two folders in your home folder (`~`). On Windows, your home folder is `C:\Users\<your name>`.

| Folder | What it holds |
| --- | --- |
| `~/beyond-vibes-labs` | Your copy of this repository: these instructions, the scripts, and the scoring sheets. You run the scripts from here. |
| `~/beyond-vibes-lab-01/pr146` | The task workspace that setup builds. `pr146` stands for Doc Detective pull request #146. |
| `~/beyond-vibes-lab-01/pr146/docs` | Doc Detective's repository before the change. Your agent works here. |
| `~/beyond-vibes-lab-01/pr146/code` | The same repository with the code change added. Your agent reads it; nobody edits it. |
| `~/beyond-vibes-lab-01/pr146/TASK.md` | The prompt you give your agent. |

Setup also builds `~/beyond-vibes-lab-01/common-pr65`, with the same layout, for the [stretch task](stretch/README.md).

The workspace sits outside your copy of this repository so your agent can't read the rubric or the worked example while it works. Doc Detective's history is removed from the workspace, so the agent can't see how the maintainer actually documented the change.

Each command block below starts with `cd` to the folder it needs, so you can run every block as written, top to bottom, wherever your terminal was before.

## Steps

Do steps 1–3 before the lab; they take about 10 minutes. In the lab, Manny works each of steps 4–8 on screen first, then you do it yourself.

On Windows, run every command in **Git Bash**, which comes with Git for Windows. To use PowerShell instead, see [Windows PowerShell](#windows-powershell).

### 1. Check what you need

- **Git.** In a terminal, `git --version` prints a version number.
- **The agent you use day to day**, installed and signed in: Claude Code, Codex, Copilot, Cursor, OpenCode, or another.
- **Your usual setup**: your user-level instructions, skills, and model settings. Testing your setup is the point.

### 2. Copy this repository to your computer

```bash
cd ~
git clone https://github.com/Promptless/beyond-vibes-labs.git
```

You'll see `Cloning into 'beyond-vibes-labs'...`, and the folder `~/beyond-vibes-labs` appears.

If you already have it, get the latest version instead:

```bash
cd ~/beyond-vibes-labs
git pull
```

### 3. Build the task workspace

```bash
cd ~/beyond-vibes-labs
lab-01/setup.sh
```

Setup takes under a minute and needs a network connection. You'll see `Setting up pr146 ...` and `done` for each task, then your task folder, then the task prompt between a `copy from the next line` marker and a `copy to the line above` marker. The same prompt is saved in `~/beyond-vibes-lab-01/pr146/TASK.md`.

If the workspace already exists, setup asks whether to replace it. Type `y` and press Enter to start fresh, or just press Enter to keep it.

### 4. Run your agent (10 minutes)

Run your agent once on the task, with web access off. Don't open the files in `lab-01/scoring/` yet.

**Claude Code:**

```bash
cd ~/beyond-vibes-lab-01/pr146/docs
claude -p "$(cat ~/beyond-vibes-lab-01/pr146/TASK.md)" \
  --add-dir ~/beyond-vibes-lab-01/pr146/code --permission-mode acceptEdits \
  --disallowedTools WebFetch WebSearch | tee ~/beyond-vibes-lab-01/pr146/my-reply.md
```

**Codex:**

```bash
cd ~/beyond-vibes-lab-01/pr146/docs
codex exec --sandbox workspace-write -c web_search='"disabled"' \
  -o ~/beyond-vibes-lab-01/pr146/my-reply.md "$(cat ~/beyond-vibes-lab-01/pr146/TASK.md)"
```

A run takes a minute or two and shows little while it works. Don't steer the agent or ask for a second draft. When your terminal prompt comes back, the agent's final reply is on screen and saved in `~/beyond-vibes-lab-01/pr146/my-reply.md`.

**Any other agent** (Copilot, Cursor, OpenCode, and so on):

1. Start a **new** session in `~/beyond-vibes-lab-01/pr146/docs`. The [agent notes](#agent-notes) give the command or settings for your tool.
2. Paste the prompt from `~/beyond-vibes-lab-01/pr146/TASK.md` as your first message. It's the same text setup printed.
3. If the agent asks a question, answer "use your judgment".
4. When it finishes, create the file `~/beyond-vibes-lab-01/pr146/my-reply.md` in any text editor and paste the agent's final message into it.

If your agent replied `NO_DOC_CHANGES_NEEDED`, that's its decision. Keep going.

### 5. Open your agent's changes

```bash
cd ~/beyond-vibes-labs
lab-01/show-patch.sh
```

You'll see two lines starting with `Saved`, and a page called `my-patch.html` opens in your browser. It lists each file the agent changed, with text it added in green and text it removed struck through in red. Only the changed parts of each file are shown; everything else in the file is unchanged. If the page doesn't open, open `~/beyond-vibes-lab-01/pr146/my-patch.html` in your browser yourself.

The script also saves the same changes as `~/beyond-vibes-lab-01/pr146/my-patch.diff`. Run it again any time to reopen the page.

### 6. Score the patch (10 minutes)

Open the [score sheet](scoring/score-sheet.md) and the [rubric](scoring/rubric-pr146.md), with `my-patch.html` beside them. The score sheet takes you through it: a verdict for each criterion with the line from the patch behind it, then the score, which you work out by hand.

Don't read the worked example's verdicts or this task's page on dogbench.ai until you've scored your patch: both show the published verdicts.

### 7. Tag the failure modes (5 minutes)

Open the [tag sheet](tags/tag-sheet.md). First mark the failure modes you see in `my-patch.html`. Then look back at what your agent did before it wrote, and mark the investigation patterns you see there.

To look back at what your agent did:

- **Claude Code:** reopen the session, then scroll up.

  ```bash
  cd ~/beyond-vibes-lab-01/pr146/docs
  claude --continue
  ```

- **Codex:** scroll up in the terminal where it ran.
- **Any other agent:** scroll up in its chat or session window.

### 8. Post your results and compare (5 minutes)

Post your score, your tags, and your tool and model to the room's results sheet, which is linked in the session chat. Don't post the patch itself.

Then read [the worked example](scoring/worked-example.md), which scores the only published patch that passed C1, line by line.

If you finish early, try the [stretch task](stretch/README.md). The session ends with a 15-minute clinic, not recorded: bring questions about your own setup's instructions, skills, models, and review habits.

## Run the task again

To rerun the task after you change your setup, rebuild a clean workspace and repeat steps 4–8. Rebuilding deletes everything in `~/beyond-vibes-lab-01/pr146`, so first move `my-patch.diff`, `my-patch.html`, and `my-reply.md` to another folder.

```bash
cd ~/beyond-vibes-labs
lab-01/setup.sh --force pr146
```

Bring the [review checklist](checklist/review-checklist.md) to your agent's next docs PR.

## Agent notes

The prompt in `~/beyond-vibes-lab-01/pr146/TASK.md` is DoGBench's frozen prompt for this task, unchanged except for two edits:

- The code path is `../code` instead of `/task/code_repo`.
- One closing line asks the agent not to browse the web.

The agents in the DoGBench paper ran without network access. Turning web access off in your tool keeps your run comparable, and stops the agent from looking up the merged pull request.

Your user-level instructions and skills load as usual. Project-level files from your own repositories (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, and so on) don't, because the agent is working in Doc Detective's repository. To test one, copy it into `~/beyond-vibes-lab-01/pr146/docs` before you start, and say so on the results sheet. The file shows up on `my-patch.html` as a new file; leave it out when you score.

Full runs of this task with Claude Code and with Codex CLI each took under a minute, using the commands in step 4. The notes for the other tools come from each tool's documentation, checked on Nov 13, 2026.

#### Claude Code

Use the command in [step 4](#4-run-your-agent-10-minutes). `-p` runs the prompt once without an interactive session, and `--permission-mode acceptEdits` lets it edit `docs/` without stopping to ask. `--add-dir` lets Claude Code read the code change without asking for each file. `--disallowedTools` removes the web tools for this session. ([CLI reference](https://code.claude.com/docs/en/cli-reference), [permissions](https://code.claude.com/docs/en/permissions))

To work interactively instead, start Claude Code like this and paste the prompt:

```bash
cd ~/beyond-vibes-lab-01/pr146/docs
claude --add-dir ~/beyond-vibes-lab-01/pr146/code --disallowedTools WebFetch WebSearch
```

#### Codex CLI

Use the command in [step 4](#4-run-your-agent-10-minutes). `codex exec` runs the prompt once, and `-o` writes the final reply to a file. The `workspace-write` sandbox limits edits to `docs/` and turns network access off. Codex can still read the `code` folder. `web_search="disabled"` turns off Codex's built-in web search, which otherwise defaults to a cached index. Don't pass `--search`. ([sandboxing](https://learn.chatgpt.com/docs/sandboxing), [config reference](https://learn.chatgpt.com/docs/config-file/config-reference))

#### GitHub Copilot CLI

```bash
cd ~/beyond-vibes-lab-01/pr146/docs
copilot --add-dir ~/beyond-vibes-lab-01/pr146/code --deny-tool='url'
```

`--add-dir` grants access to the code change. `--deny-tool='url'` blocks URL access through web fetch and the shell. ([command reference](https://docs.github.com/en/copilot/reference/cli-command-reference))

#### Cursor

- **Editor:** open `~/beyond-vibes-lab-01/pr146/docs` as the folder, then start a new Agent chat.
- **CLI:** run `agent --workspace ~/beyond-vibes-lab-01/pr146/docs`.

Cursor reads files outside the workspace, including the `code` folder, without asking by default. Its docs don't describe a switch that turns off the web search tool. To hold web fetches for your approval, set **Settings > Agents > Approvals & Execution** to **Allowlist**, and decline any web request the agent makes. ([agent security](https://cursor.com/docs/agent/security), [CLI permissions](https://cursor.com/docs/cli/reference/permissions))

#### OpenCode

Before you start, create the file `~/beyond-vibes-lab-01/pr146/docs/opencode.jsonc` to turn off web fetch and web search. OpenCode 2 uses this form:

```jsonc
{
  "permissions": [
    { "action": "webfetch", "resource": "*", "effect": "deny" },
    { "action": "websearch", "resource": "*", "effect": "deny" }
  ]
}
```

OpenCode 1 uses `{ "permission": { "webfetch": "deny", "websearch": "deny" } }`. Then start OpenCode in the workspace:

```bash
opencode ~/beyond-vibes-lab-01/pr146/docs
```

OpenCode 1 asks before it reads the `code` folder. Approve that read when it asks. `opencode.jsonc` shows up on `my-patch.html` as a new file; leave it out when you score. ([permissions](https://opencode.ai/docs/permissions/), [migrating from v1](https://opencode.ai/docs/migrate-v1/))

#### Any other agent

Start it in `~/beyond-vibes-lab-01/pr146/docs`, let it read `~/beyond-vibes-lab-01/pr146/code`, and turn off web access if the tool allows it. If it can't be turned off, note that on the results sheet.

#### Windows PowerShell

The scripts also run from PowerShell. They need Git for Windows, which they use behind the scenes.

Build the workspace (step 3):

```powershell
cd ~\beyond-vibes-labs
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1
```

Open your agent's changes (step 5):

```powershell
cd ~\beyond-vibes-labs
powershell -ExecutionPolicy Bypass -File .\lab-01\show-patch.ps1
```

Rebuild a clean workspace:

```powershell
cd ~\beyond-vibes-labs
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1 --force pr146
```

The Claude Code and Codex commands in step 4 are written for Git Bash. In PowerShell, start your agent interactively in `~\beyond-vibes-lab-01\pr146\docs` and paste the prompt from `~\beyond-vibes-lab-01\pr146\TASK.md`.

## Credits

- The task, the rubric, and the frozen prompt come from [DoGBench](https://dogbench.ai) ([code](https://github.com/Promptless/dogbench), [dev split](https://huggingface.co/datasets/promptless-research/dogbench-dev)).
- The code change is [doc-detective/doc-detective#146](https://github.com/doc-detective/doc-detective/pull/146). The stretch task's code change is [doc-detective/common#65](https://github.com/doc-detective/common/pull/65). Doc Detective is AGPL-3.0, and setup downloads it from GitHub rather than copying it into this repository.
- [LICENSE-CONTENT.md](../LICENSE-CONTENT.md) lists which license applies to each file.
