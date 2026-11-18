# Stretch task: should it write at all?

For fast finishers. This task tests the decision before the writing: does this code change need a documentation update?

- **Item:** `doc-detective-common-pr65` from the DoGBench public dev split
- **Code change:** adds an Arazzo description schema to Doc Detective's shared schema library and wires it into the config and spec schemas (8 files)
- **Docs:** the Doc Detective documentation site
- **Expected outcome:** no documentation change. DoGBench's maintainer-validated label for this item is "abstain".

## Run it

Setup builds this task's workspace, `~/beyond-vibes-lab-01/common-pr65`, alongside pr146's. If that folder is missing, build it now:

```bash
cd ~/beyond-vibes-labs
lab-01/setup.sh common-pr65
```

In PowerShell:

```powershell
cd ~\beyond-vibes-labs
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1 common-pr65
```

Then run it the way you ran pr146, in this task's folder. This task has its own code change in `~/beyond-vibes-lab-01/common-pr65/code`, so give your agent that folder, not pr146's. For Claude Code:

```bash
cd ~/beyond-vibes-lab-01/common-pr65/docs
claude -p "$(cat ~/beyond-vibes-lab-01/common-pr65/TASK.md)" \
  --add-dir ~/beyond-vibes-lab-01/common-pr65/code --permission-mode acceptEdits \
  --disallowedTools WebFetch WebSearch | tee ~/beyond-vibes-lab-01/common-pr65/my-reply.md
```

For other tools, use the [agent notes](../README.md#agent-notes) with `common-pr65` in place of `pr146` in every path. With an interactive tool, start a **new** session, paste the prompt from `~/beyond-vibes-lab-01/common-pr65/TASK.md`, and let it finish without steering it.

## Score it

| Result | Score |
| --- | --- |
| The agent replied `NO_DOC_CHANGES_NEEDED` and changed no files | 100 |
| The agent wrote a patch, or said no change was needed but edited files anyway | 0 |

Check whether the agent edited any files:

```bash
cd ~/beyond-vibes-labs
lab-01/show-patch.sh common-pr65
```

In PowerShell:

```powershell
cd ~\beyond-vibes-labs
powershell -ExecutionPolicy Bypass -File .\lab-01\show-patch.ps1 common-pr65
```

The page that opens says either that the agent didn't change any files or which files it changed. The agent's final reply is in `~/beyond-vibes-lab-01/common-pr65/my-reply.md`.

## If it wrote a patch, find the cue that misled it

Read the transcript for the moment the agent decided to write, and note what pulled it in:

- **A name that sounds user-facing.** "Arazzo", "schema", and "config" all sound like things readers configure.
- **A page that mentions the component.** The docs already describe config and spec files, so a new field in their schemas looks like it belongs there.
- **Something else.** Write it down and bring it to the clinic.

Post the result as a separate row on the results sheet with the task name `common-pr65`.
