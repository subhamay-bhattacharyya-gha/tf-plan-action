# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repo publishes a single GitHub composite action (`action.yaml`) that runs `terraform plan`. There is no application source code — the "product" is `action.yaml` plus its docs. Everything else (Node `package.json`, `scripts/plugins/`) exists to power semantic-release versioning, not runtime behavior.

## Common commands

- `npm ci` — install dev deps (only needed for release tooling).
- `npx semantic-release` — runs via `.github/workflows/release.yaml` on push to `main`; rarely invoked locally.
- `npx cz` / `git cz` — commitizen prompt for Conventional Commits (required for semantic-release to compute versions).
- There are no unit tests, linters, or build steps. Validation happens by running the action in a workflow (see `.github/workflows/example.yml` and `examples/`).

## Architecture

### action.yaml (the whole product)

A composite action with a fixed step sequence — order matters, because later steps depend on auth/credentials established earlier:

1. **Debug + Validate** — prints inputs, then hard-fails if required inputs for the chosen `backend-type` / `cloud-provider` combo are missing.
2. **Checkout** — uses `release-tag` if set, else current ref.
3. **Setup Terraform**.
4. **Cloud auth (OIDC)** — conditional steps for AWS (`configure-aws-credentials`), Azure (`azure/login`), GCP (`google-github-actions/auth`). Snowflake/Databricks auth is expected via env vars set by the *calling* workflow, not by this action. The AWS auth step also fires when `backend-type == s3` (S3 needs AWS creds even for non-AWS clouds).
5. **Backend init** — mutually exclusive: either writes `~/.terraform.d/credentials.tfrc.json` and runs `terraform init` for `remote` (HCP Terraform Cloud), or computes an S3 state key and runs `terraform init -backend-config=...` for `s3`.
6. **Plan** — `terraform plan -out` + `terraform show` piped into `$GITHUB_STEP_SUMMARY`, then uploads the `.out` file as an artifact.
7. **Cleanup** — removes the TFC credentials file on `always()`.

Key cross-cutting concepts:
- **`cloud-provider: platform`** — special mode that auto-detects which clouds are in use by looking for `infra/aws`, `infra/gcp`, `infra/azure` directories, and validates inputs only for the ones it finds.
- **S3 state key layout** — `{repo}/{sha}/terraform.tfstate` when `ci-pipeline=true`, otherwise `{repo}/terraform.tfstate`. Toggling `ci-pipeline` changes state isolation semantics, so don't flip it on an existing project without a migration plan.
- **Remote backend config** — this action does NOT write backend blocks; organization/workspace must already be in the consumer's `.tf` files.

### Release pipeline (`scripts/plugins/`, `.releaserc.json`, `package.json`)

`scripts/plugins/release.config.js` is the real semantic-release config (referenced from `package.json`'s `release.extends`). Plugin order: commit-analyzer → release-notes-generator → changelog → git → github. Commits must follow Conventional Commits or no release is cut. The `scripts/plugins/{analyze-commits,generate-notes,prepare,publish,verify-conditions}.js` files are stubs/custom plugin slots — check their contents before assuming they do anything.

### Examples

`examples/s3-backend/` and `examples/tfc-backend/` are minimal Terraform configs used by `.github/workflows/example.yml` to smoke-test the action against both backends.

## Editing conventions specific to this repo

- Treat `action.yaml` input additions as breaking-API-adjacent: update the README input tables in the same commit, and pick a commit type (`feat:` vs `fix:` vs `feat!:`) deliberately — it directly drives the next version number.
- When adding a new `cloud-provider` value, update both the `Validate Input Configuration` allowlist and the corresponding auth step's `if:` guard; missing either causes silent skips or validation failures far from the root cause.
- Conditional steps rely on `inputs.*` string comparisons (e.g. `inputs.backend-type == 's3'`). Don't refactor to boolean expressions — composite-action inputs are always strings.
