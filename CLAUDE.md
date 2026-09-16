# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repo publishes a single GitHub composite action (`action.yaml`) that runs `terraform plan`. There is no application source code — the "product" is `action.yaml` plus its docs. Everything else (Node `package.json`, `scripts/plugins/`) exists to power semantic-release versioning, not runtime behavior.

## Common commands

- `npm ci` — install dev deps (only needed for release tooling).
- `npx semantic-release` — runs via `.github/workflows/release.yaml` on push to `main`; rarely invoked locally.
- `npx cz` / `git cz` — commitizen prompt for Conventional Commits (required for semantic-release to compute versions).
- There are no unit tests, linters, or build steps. Validation happens by running the action in a workflow (see `.github/workflows/example.yaml` and `examples/`).

### Testing and validation

Since this is a GitHub Action with no local test suite, changes are validated by:

1. **Manually testing** the action in `.github/workflows/example.yaml` with different input combinations
2. **Using `.github/workflows/create-branch.yaml`** to create feature branches for testing (if needed for long-running validations)
3. **Dry-run semantics**: Commit changes without merging to `main` first; the release pipeline only runs on pushes to `main`

Before pushing to `main`, verify:

- Syntax is valid YAML
- Input documentation matches `action.yaml` (see editing conventions below)
- For input additions, README tables are updated with the same commit
- Conditional step guards (`if:` clauses) cover all new `cloud-provider` or `backend-type` values

## Commit message conventions

**All commits must follow Conventional Commits** — this is strictly enforced by semantic-release, which runs on every push to `main`. Use `npx cz` or `git cz` (commitizen) to create compliant messages.

**Commit type directly drives version bumps:**

- `feat:` → minor version bump (e.g., 1.0.0 → 1.1.0). Used when adding new inputs, cloud providers, or features.
- `fix:` → patch version bump (e.g., 1.0.0 → 1.0.1). Used for bug fixes or improved behavior without new capabilities.
- `feat!:` or `fix!:` → major version bump (e.g., 1.0.0 → 2.0.0). Used for breaking changes like removing inputs or changing behavior. Requires explicit justification.
- `chore:`, `docs:`, `refactor:` → no release cut; commit is recorded in git but no version bump.

**Commit bodies and footers:**

- Use the body to explain *why* the change was needed, not *what* changed (diffs show that).
- Footers: `Fixes #123` links to a GitHub issue; `BREAKING CHANGE: <description>` triggers a major bump.

**Why this matters:** A single bad commit type will bump the version incorrectly or miss a release entirely. This directly affects users upgrading the action.

## Architecture

### action.yaml (the whole product)

A composite action with a fixed step sequence — order matters, because later steps depend on auth/credentials established earlier:

1. **Debug + Validate** — prints inputs, then hard-fails if required inputs for the chosen `backend-type` / `cloud-provider` combo are missing. Validation logic is in shell scripts in the step.
2. **Checkout** — uses `release-tag` if set, else current ref.
3. **Setup Terraform**.
4. **Cloud auth (OIDC)** — conditional steps for AWS (`configure-aws-credentials`), Azure (`azure/login`), GCP (`google-github-actions/auth`). Snowflake/Databricks auth is expected via env vars set by the *calling* workflow, not by this action. The AWS auth step also fires when `backend-type == s3` (S3 needs AWS creds even for non-AWS clouds).
5. **Backend init** — mutually exclusive: either writes `~/.terraform.d/credentials.tfrc.json` and runs `terraform init` for `remote` (HCP Terraform Cloud), or computes an S3 state key and runs `terraform init -backend-config=...` for `s3`.
6. **Plan** — `terraform plan -out=tfplan.binary` saves the binary plan, then `terraform show -json tfplan.binary > tfplan.json` exports JSON. Both are uploaded as artifacts.
7. **Summary** — pipes the plan to `$GITHUB_STEP_SUMMARY` with formatted markdown output (or just the URL for HCP Terraform Cloud).
8. **Cleanup** — removes the TFC credentials file on `always()`.

Key cross-cutting concepts:

- **Validation matrix** — The `Validate Input Configuration` step checks all required inputs for the chosen `cloud-provider` and `backend-type`. If using `cloud-provider: platform`, it auto-detects which directories exist in `infra/` and only validates inputs for those platforms.
- **`cloud-provider: platform`** — special mode that auto-detects which clouds are in use by looking for `infra/aws`, `infra/gcp`, `infra/azure`, `infra/snowflake`, `infra/databricks` directories, and validates inputs only for the ones it finds.
- **S3 state key layout** — `{repo}/{sha}/terraform.tfstate` when `ci-pipeline=true`, otherwise `{repo}/terraform.tfstate`. Toggling `ci-pipeline` changes state isolation semantics, so don't flip it on an existing project without a migration plan. The `{repo}` part is derived from the GitHub repository name at runtime.
- **Remote backend config** — this action does NOT write backend blocks; organization/workspace must already be in the consumer's `.tf` files. The action only authenticates and runs `terraform init` against existing backend configuration.

### Release pipeline (`scripts/plugins/`, `.releaserc.json`, `package.json`)

The release workflow **only runs on pushes to `main`**:

1. **Trigger:** `.github/workflows/release.yaml` runs `semantic-release` when code lands on `main`.
2. **Analyze:** semantic-release reads all commits since the last release, groups them by type (feat/fix/etc), and computes the next version.
3. **Generate:** Changelog is generated from commit messages.
4. **Git + GitHub:** A release commit is pushed to `main` with updated CHANGELOG.md, and a GitHub Release is created with the tag and notes.
5. **No action version update:** The action repo itself does NOT have a `version:` field in `action.yaml`; versioning is external (consumers use `@v1.0.0` tags).

Real config: `scripts/plugins/release.config.js` (referenced from `package.json`'s `release.extends`). Plugin order: commit-analyzer → release-notes-generator → changelog → git → github. The `scripts/plugins/{analyze-commits,generate-notes,prepare,publish,verify-conditions}.js` files are stubs/custom plugin slots — check their contents before assuming they do anything.

### Examples

`examples/s3-backend/` and `examples/tfc-backend/` are minimal Terraform configs used by `.github/workflows/example.yaml` to smoke-test the action against both backends. If validating a new feature, run the example workflow manually with your changes to confirm the action still works end-to-end.

## Editing conventions specific to this repo

### Input additions and changes

- **Treat `action.yaml` input additions as API changes:** update the README input tables in the same commit.
- **Pick a commit type deliberately:** `feat:` for new inputs, `fix:` for bug fixes, `feat!:` for removals. This directly drives the version bump.
- **Update README sections:** If adding an input, update the corresponding README section (e.g., "Common Inputs", "Cloud Provider Authentication Inputs") with the same PR.
- **Link to usage examples:** Include workflow snippets in the README showing the new input in action, if it's a new feature.

### Adding new cloud providers or backends

- **Update validation allowlist:** The `Validate Input Configuration` step has a hardcoded list of allowed `cloud-provider` and `backend-type` values. Add your new value(s).
- **Update auth step guards:** If adding a new cloud provider, add a conditional step (or update an existing `if:` clause) to handle authentication. Example: `if: inputs.cloud-provider == 'mynewcloud'`.
- **Update README:** Add sections for the new cloud provider following the existing pattern (AWS, GCP, Azure, Snowflake, Databricks).
- **Test with examples:** Create a minimal Terraform config in `examples/` and add a test job to `.github/workflows/example.yaml`.

### Conditional steps and string logic

- Conditional steps rely on `inputs.*` string comparisons (e.g., `inputs.backend-type == 's3'`). Composite-action inputs are always strings, never booleans.
- Don't refactor string comparisons into bash conditionals or boolean logic — keep them in the YAML `if:` clauses for clarity.
- When debugging a missing auth step or backend init, first check the `if:` clause matches the input values being passed.

### Outputs and artifacts

- The action outputs plan artifacts (binary and JSON) and metadata (status, resource counts, run URL for HCP Terraform Cloud).
- Outputs are documented in the README — if you change output names or structure, update the README `Outputs` section and any examples that consume them.
- The `plan-binary-path` and `plan-json-path` outputs are relative to `tf-config-path`, not the repo root.
