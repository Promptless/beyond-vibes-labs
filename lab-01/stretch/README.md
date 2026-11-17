# Stretch task: should it write at all?

For fast finishers. This task tests the decision before the writing: does this code change need a documentation update?

- **Item:** `doc-detective-common-pr65` from the DoGBench public dev split
- **Code change:** adds an Arazzo description schema to Doc Detective's shared schema library and wires it into the config and spec schemas (8 files)
- **Docs:** the Doc Detective documentation site
- **Expected outcome:** no documentation change. DoGBench's maintainer-validated label for this item is "abstain".

## Run it

`setup.sh` builds this workspace alongside pr146. If you set up only pr146, build it now from your `beyond-vibes-labs` clone:

```bash
lab-01/setup.sh common-pr65
```

In PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\lab-01\setup.ps1 common-pr65
```

Then do what you did for pr146:

1. Start a **new** agent session in `~/lab-01-tasks/common-pr65/docs`.
2. Paste the prompt setup printed, everything between the two copy markers. It's also in `~/lab-01-tasks/common-pr65/TASK.md`.
3. Let it finish without steering it.

## Score it

| Result | Score |
| --- | --- |
| The agent replied `NO_DOC_CHANGES_NEEDED` and changed no files | 100 |
| The agent wrote a patch, or said no change was needed but edited files anyway | 0 |

Check for edits with:

```bash
cd ~/lab-01-tasks/common-pr65/docs
git status --short
```

No output means no edits.

## If it wrote a patch, find the cue that misled it

Read the transcript for the moment the agent decided to write, and note what pulled it in:

- **A name that sounds user-facing.** "Arazzo", "schema", and "config" all sound like things readers configure.
- **A page that mentions the component.** The docs already describe config and spec files, so a new field in their schemas looks like it belongs there.
- **Something else.** Write it down and bring it to the clinic.

Post the result as a separate row on the results sheet with the task name `common-pr65`.
