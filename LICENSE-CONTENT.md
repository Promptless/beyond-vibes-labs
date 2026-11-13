# Content licenses

Different parts of this repository carry different licenses.

| What | License |
| --- | --- |
| Scripts: `lab-01/setup.sh`, `lab-01/setup.ps1`, `.github/` | [Apache License 2.0](LICENSE), with attribution in [NOTICE](NOTICE) |
| Lab guides, score sheet, worked example, tag sheet, review checklist: every Markdown file not listed below | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) |
| DoGBench rubric: `lab-01/scoring/rubric-pr146.md` | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/), reproduced unmodified from the DoGBench dataset ([dataset license](https://github.com/Promptless/dogbench/blob/main/DATASET_LICENSE.md)) |
| DoGBench task prompts: `lab-01/tasks/*.prompt.md` | Item text: CC BY-NC-ND 4.0 (DoGBench dataset). Quoted pull-request titles and descriptions keep their upstream licenses. |
| The quoted agent patch in `lab-01/scoring/worked-example.md` | Published by Promptless on [dogbench.ai](https://dogbench.ai) and quoted with its judge verdicts; the Doc Detective README text it changes is AGPL-3.0 |

`setup.sh` downloads Doc Detective's repositories from GitHub when you run it. They aren't stored in this repository, and they keep their own licenses: `doc-detective/doc-detective` and `doc-detective/common` are AGPL-3.0, and `doc-detective/doc-detective.github.io` is MIT.

To attribute the lab materials, credit "Beyond Vibes AI Labs, Promptless" and link to this repository.
