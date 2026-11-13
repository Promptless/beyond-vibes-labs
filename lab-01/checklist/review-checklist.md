# Review checklist for an agent-written docs PR

Use this when your agent opens a documentation pull request. Each check targets a failure mode or investigation pattern that DoGBench found often in agent-written patches. The rate in brackets is the share of 1,267 audited submissions that had the problem.

## Before you read the diff

- [ ] **Should this change touch the docs at all?** Ask what a reader can do after this change that they couldn't do before. If the answer is "nothing," the right patch is no patch.
- [ ] **What did the agent read?** Skim its transcript or summary. Did it open the code change, the pages it edited, *and* the pages it didn't edit?

## Accuracy

- [ ] **Every claim traces to the code.** For each statement about behavior, find the line in the change or the existing code that supports it. Pay extra attention to claims about edge cases the change only partly handles. *Technical inaccuracy [36.6%]*
- [ ] **No gaps filled by guesswork.** Look for confident sentences about things the change doesn't show: defaults, supported formats, protocols, limits. *Missed decisive evidence [33.1%]*
- [ ] **Nothing invented.** Every flag, setting, field, and example exists in the product. *Fabricated content [6.1%]*

## Completeness

- [ ] **The reader can finish the task.** The page covers the decision, the steps, how to check that it worked, and what to do when it doesn't. *Task-completion gap [45.5%]*
- [ ] **The whole interface is covered.** Aliases, short flags, alternative forms, and every input type the feature accepts. *Incomplete conceptual or reference coverage [32.5%]*
- [ ] **Examples are runnable.** At least one example a reader can copy and run, using the syntax the product actually accepts. *Missing supporting information [26.5%]*
- [ ] **Setup is stated.** Versions, permissions, dependencies, and configuration the feature needs. *Missing prerequisites [21.0%]*
- [ ] **When and why.** One sentence telling the reader when they'd use this. *Missing audience and purpose framing [19.9%]*

## Fit with the rest of the docs

- [ ] **It matches how readers already use the product.** New text follows the page's existing commands, terminology, and formatting. *Described an interface without checking how readers use it [36.0%]*
- [ ] **Every affected page changed.** Search the docs for the feature's names and flags, and check every hit, not just the page the agent edited. *Edited the first plausible page [30.1%]; Cross-surface content inconsistency [13.3%]*
- [ ] **Readers can find it.** The content sits where readers of this feature will look, and it's linked from there. *Information-architecture or findability failure [20.7%]*
- [ ] **Nothing correct was lost.** Existing statements about defaults and precedence still read the same.
