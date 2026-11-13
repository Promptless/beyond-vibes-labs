You are responsible for maintaining this project's user-facing documentation.

Review the provided code change or task request, then inspect the existing documentation to determine whether users need any documentation updates.

- If no user-facing documentation update is warranted, return `NO_DOC_CHANGES_NEEDED` and briefly explain why.
- If an update is warranted, make the necessary changes in the documentation workspace.

Provided code change: The source code is available read-only in `/task/code_repo`; the change is its latest local commit.

Frozen change framing:
Title: feat: add Arazzo description schema and integrate into config and spec schemas
Description: Introduces a new JSON Schema definition for Arazzo descriptions, covering the `name`, `descriptionPath`, `workflowId`, and `inputs` properties. The schema enforces that `workflowId` and `inputs` are only permitted at the individual test level, while `name` and `descriptionPath` are required when Arazzo entries appear at the configuration level.

The config and spec schemas are updated to accept an `arazzo` array field, with each item validated against the new schema via `allOf` composition. The spec schema's test items union is widened from `oneOf` to `anyOf` to accommodate both existing test objects and Arazzo workflow references.

The schema dereference pipeline is updated to include the new Arazzo schema file, ensuring it is resolved and inlined into the output schemas alongside existing definitions.
For this run, the documentation workspace is the current checkout.