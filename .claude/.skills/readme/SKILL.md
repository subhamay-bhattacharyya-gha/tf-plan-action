---
name: readme
description: README documentation guidelines for tf-plan-action
user-invocable: true
metadata:
  category: project-specific
---

# README Skill — tf-plan-action

README documentation guidelines and best practices for the Terraform Plan GitHub Action.

## Overview

The README.md is the first thing users see. It should clearly communicate:
- What the action does (run `terraform plan` with multi-cloud support)
- How to use it (inputs, outputs, examples)
- Supported cloud providers and backends
- How to authenticate and configure
- Troubleshooting and support

## Key File: README.md

Located at repository root: [README.md](../../../README.md)

## Essential Sections

A good README includes these sections in order:

### 1. Title & Badge Section

```markdown
# Terraform Plan — GitHub Action

[![GitHub Release](badge-url)](link)
[![License: MIT](badge-url)](link)
[![Terraform](badge-url)](link)
```

Quick status indicators and badges at top. **Keep this section intact when updating the README.**

### 2. Description

Brief explanation of what this action is:

```markdown
A GitHub composite action that runs `terraform plan` with support for:
- Multiple cloud providers: AWS, GCP, Azure, Snowflake, Databricks
- Multiple backends: AWS S3, HCP Terraform Cloud
- OIDC authentication for secure, keyless access
- Binary and JSON plan artifacts
- Detailed resource change summaries
```

### 3. Quick Start / Usage

How users get started immediately:

```markdown
## Quick Start

### Basic S3 Backend + AWS Authentication

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@v1.6.0
  with:
    cloud-provider: aws
    backend-type: s3
    s3-bucket: my-terraform-state
    s3-region: us-east-1
    aws-region: us-east-1
    aws-role-to-assume: arn:aws:iam::123456789012:role/terraform-role
    tf-config-path: tf
```

### HCP Terraform Cloud + GCP Authentication

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@v1.6.0
  with:
    cloud-provider: gcp
    backend-type: remote
    tfc-token: ${{ secrets.TFC_API_TOKEN }}
    gcp-wif-provider: projects/123456/locations/global/workloadIdentityPools/.../providers/...
    gcp-service-account: terraform@my-project.iam.gserviceaccount.com
```
```

### 4. Features / Capabilities

What this action provides:

```markdown
## Features

- ✅ Multi-cloud support: AWS, GCP, Azure, Snowflake, Databricks
- ✅ Multiple backends: AWS S3 or HCP Terraform Cloud
- ✅ OIDC authentication (no long-lived credentials)
- ✅ Input validation for cloud providers and backends
- ✅ Binary and JSON plan artifacts
- ✅ Resource change summaries (add, update, delete, replace, no-op counts)
- ✅ HCP Terraform Cloud run URL extraction
- ✅ Platform mode for multi-cloud auto-detection
```

### 5. Inputs & Outputs

Document all inputs grouped by purpose:

```markdown
## Inputs

### Cloud Provider & Backend

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `cloud-provider` | Yes | — | aws, gcp, azure, snowflake, databricks, platform |
| `backend-type` | No | s3 | s3 or remote |
| `tf-config-path` | No | tf | Path to Terraform configuration |

### AWS S3 Backend

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `s3-bucket` | Yes* | — | S3 bucket name (*required if backend-type is s3) |
| `s3-region` | Yes* | — | AWS region for S3 bucket |

### HCP Terraform Cloud Backend

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `tfc-token` | Yes* | — | API token (*required if backend-type is remote) |

### Cloud Authentication

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `aws-region` | Yes* | — | AWS region (*if cloud-provider is aws) |
| `aws-role-to-assume` | Yes* | — | IAM role ARN (*if cloud-provider is aws) |
| `gcp-wif-provider` | Yes* | — | GCP WIF provider (*if cloud-provider is gcp) |
| `gcp-service-account` | Yes* | — | GCP service account email (*if cloud-provider is gcp) |

## Outputs

| Output | Description |
|--------|-------------|
| `plan-status` | Success or failure of terraform plan |
| `plan-binary-path` | Path to binary Terraform plan file |
| `plan-json-path` | Path to JSON representation of plan |
| `resources-to-add` | Count of resources to create |
| `resources-to-change` | Count of resources to update |
| `resources-to-destroy` | Count of resources to delete |
| `plan-summary` | One-line summary (e.g., "3 to add, 2 to change, 1 to destroy") |
| `run-url` | HCP Terraform Cloud run URL (if remote backend) |
```

### 6. Authentication Setup

Prerequisites and authentication configuration:

```markdown
## Authentication Setup

### AWS OIDC Setup

1. Create an IAM role with OIDC trust relationship for GitHub Actions
2. Configure the role ARN as `aws-role-to-assume`
3. Ensure the role has Terraform permissions for your infrastructure

```yaml
permissions:
  id-token: write
  contents: read
```

### GCP Workload Identity Federation

1. Set up WIF provider and service account
2. Configure WIF provider URL as `gcp-wif-provider`
3. Configure service account email as `gcp-service-account`

### Azure Service Principal

1. Create a service principal with Terraform permissions
2. Configure `azure-client-id`, `azure-tenant-id`, `azure-subscription-id`
```

### 7. Usage Examples

Real-world usage patterns:

```markdown
## Usage Examples

### S3 Backend + AWS

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@v1
  with:
    cloud-provider: aws
    backend-type: s3
    s3-bucket: my-terraform-state
    s3-region: us-east-1
    aws-region: us-east-1
    aws-role-to-assume: arn:aws:iam::123456789012:role/terraform-role
    tf-config-path: tf
```

### Remote Backend + GCP + CI Pipeline Mode

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@v1
  with:
    cloud-provider: gcp
    backend-type: remote
    tfc-token: ${{ secrets.TFC_API_TOKEN }}
    gcp-wif-provider: projects/123456/locations/global/workloadIdentityPools/.../providers/...
    gcp-service-account: terraform@my-project.iam.gserviceaccount.com
    tf-config-path: infra/gcp
    ci-pipeline: true

### Platform Mode (Multi-Cloud Auto-Detection)

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@v1
  with:
    cloud-provider: platform
    backend-type: s3
    s3-bucket: multi-cloud-state
    s3-region: us-east-1
    aws-region: us-east-1
    aws-role-to-assume: arn:aws:iam::123456789012:role/terraform-role
    gcp-wif-provider: projects/123456/locations/global/workloadIdentityPools/.../providers/...
    gcp-service-account: terraform@my-project.iam.gserviceaccount.com
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```
```

### 8. Configuration / Options

Detailed configuration guide:

```markdown
## Configuration

### Backend Selection

Choose one backend type:

- **s3**: AWS S3 for state storage. Requires `s3-bucket` and `s3-region`.
- **remote**: HCP Terraform Cloud. Requires `tfc-token` and existing `.tf` backend config.

### Cloud Provider Selection

- **aws**: AWS with OIDC. Requires `aws-region` and `aws-role-to-assume`.
- **gcp**: Google Cloud with WIF. Requires `gcp-wif-provider` and `gcp-service-account`.
- **azure**: Azure with OIDC. Requires `azure-client-id`, `azure-tenant-id`, `azure-subscription-id`.
- **snowflake**: Snowflake. Auth via environment variables.
- **databricks**: Databricks. Auth via environment variables.
- **platform**: Auto-detect clouds from infra/ directories. Validates inputs for detected clouds.

### Optional Configuration

- `ci-pipeline`: Set to `true` to include commit SHA in S3 state key for isolation.
- `verbose-plan-output`: Set to `true` to stream full terraform plan output.
- `release-tag`: Checkout specific Git tag before running.
- `tf-vars-file`: Path to terraform.tfvars file (default: terraform.tfvars).
```

### 9. Development & Contributing

For contributors:

```markdown
## Development

### Making Changes

1. Edit `action.yaml` for new inputs, outputs, or step changes
2. Test locally or via `.github/workflows/example.yaml`
3. Update README.md if adding inputs or features
4. Use Conventional Commits for commit messages

```bash
# Create a compliant commit
npx cz

# Or manually (feat: for features, fix: for bugs)
git commit -m "feat: add new cloud provider"
```

### Versioning

This action uses semantic-release for automatic versioning:
- `feat:` commits → minor version bump (1.0.0 → 1.1.0)
- `fix:` commits → patch version bump (1.0.0 → 1.0.1)
- `feat!:` / `fix!:` commits → major version bump (1.0.0 → 2.0.0)

Release is triggered automatically when commits are pushed to `main`.

See [CLAUDE.md](../../../CLAUDE.md) for architecture and commit conventions.
```

### 10. How It Works

Explain the action's workflow:

```markdown
## How It Works

The action executes the following steps in order:

1. **Validate Inputs** — Checks required inputs for chosen cloud provider and backend
2. **Checkout Code** — Clones repository (or specific release tag)
3. **Setup Terraform** — Installs Terraform (v1.0+)
4. **Cloud Authentication** — Authenticates with cloud provider (OIDC)
5. **Backend Initialization** — Initializes S3 or HCP Terraform Cloud backend
6. **Run Plan** — Executes `terraform plan -out=tfplan.binary`
7. **Export Plan** — Converts binary plan to JSON
8. **Generate Summary** — Creates markdown summary with resource counts
9. **Upload Artifacts** — Saves binary and JSON plans as GitHub artifacts
10. **Cleanup** — Removes temporary credentials (TFC token file)

See [action.yaml](action.yaml) for implementation details.
```

### 11. Troubleshooting

Common issues and solutions:

```markdown
## Troubleshooting

### Missing Required Inputs

**Error**: `Error: aws-region and aws-role-to-assume are required when cloud-provider is 'aws'`

**Solution**: Verify all required inputs for your cloud provider are provided. Use the Inputs table above.

### OIDC Authentication Fails

**Error**: `error assuming role: AccessDenied`

**Solution**: 
1. Verify the OIDC trust relationship in IAM role
2. Check role ARN is correct
3. Ensure workflow has `permissions: { id-token: write }`

### Terraform State Initialization Fails

**Error**: `Error: error in backend initialization`

**Solution**:
- For S3: Verify bucket exists and credentials have access
- For Remote: Verify TFC token is valid and workspace exists in .tf files

### Plan Artifacts Not Generated

**Solution**: 
1. Check terraform plan succeeded (no syntax errors)
2. Verify `tf-config-path` is correct
3. Check `.tf` files exist in the path

### Platform Mode Skips Clouds

**Solution**: Verify `infra/aws/`, `infra/gcp/`, etc. directories exist
```

### 12. Contributing

Link to contribution guidelines:

```markdown
## Contributing

We welcome contributions! Please see [CLAUDE.md](CLAUDE.md) for project structure and guidelines.

Process:
1. Fork repository
2. Create feature branch
3. Make changes to `action.yaml`
4. Update README if adding inputs/features
5. Use Conventional Commits (`npx cz`)
6. Create pull request
7. Get review and merge to `main`

Use the [terraform-plan skill](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/tree/main/.claude/skills/terraform-plan) for local testing.

Automatic release occurs when changes are merged to `main`.
```

### 13. License

```markdown
## License

This project is licensed under the [MIT License](LICENSE).
```

### 14. Support & Help

```markdown
## Support & Resources

- 📖 [Project Documentation](CLAUDE.md) — Architecture and conventions
- 🚀 [Terraform Plan Skill](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/tree/main/.claude/skills/terraform-plan) — Local CLI tool
- 🐛 [Report Issues](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/issues)
- 📝 [Examples](examples/) — Sample workflows and configurations
```

## Formatting Guidelines

### Markdown Best Practices

- **Use headers** for structure (# > ## > ###)
- **Bold key terms** for emphasis
- **Use code blocks** for examples (```language)
- **Use tables** for structured data
- **Use lists** for multiple items
- **Link internally** to related files
- **Add emojis** for visual interest (optional)

### Code Examples

Always specify language in code blocks:

````markdown
```yaml
# YAML example
name: Example
```

```bash
# Bash example
npm install
```

```javascript
// JavaScript example
const action = require('action');
```
````

### Links

```markdown
# Internal links
[CONTRIBUTING.md](CONTRIBUTING.md)
[action.yaml](./action.yaml)

# External links
[GitHub Actions Docs](https://docs.github.com/actions)
```

## Content Quality

### Do's

✅ Keep README focused on the main purpose  
✅ Use clear, simple language  
✅ Provide working examples  
✅ Update when features change  
✅ Include links to related docs  
✅ Add examples for common use cases  
✅ Be welcoming to new users  

### Don'ts

❌ Don't make it too long (keep under 500 lines)  
❌ Don't mix multiple projects in one README  
❌ Don't include outdated examples  
❌ Don't require extensive background knowledge  
❌ Don't forget to update after changes  

## README Structure for tf-plan-action

```markdown
# Terraform Plan — GitHub Action

[Badges — keep intact during updates]

Brief description of what the action does

## Features

Key capabilities (multi-cloud, backends, OIDC, etc.)

## Quick Start

Minimal working examples for S3+AWS and Remote+GCP

## Authentication Setup

Prerequisites and setup for each cloud provider

## Inputs

Grouped input tables:
- Cloud Provider & Backend
- AWS S3 Backend
- HCP Terraform Cloud Backend
- Cloud Authentication (AWS, GCP, Azure)
- Optional inputs (ci-pipeline, verbose-plan-output, etc.)

## Outputs

Output table with descriptions

## Usage Examples

Real-world examples:
- S3 + AWS
- Remote + GCP
- Platform mode (auto-detect)

## Configuration

Available options and how to choose backends/providers

## How It Works

Explain the step-by-step workflow

## Troubleshooting

Common errors and solutions

## Contributing

Link to CLAUDE.md and development process

## License

License info

## Support & Resources

Links to docs, skills, examples, issues
```

## Keeping README Updated

- **When adding inputs**: Update the Inputs table in the same commit
- **When adding cloud providers**: Add authentication setup and examples
- **When changing defaults**: Update the Inputs table and examples
- **When fixing bugs**: Add troubleshooting entries if new issue emerges
- **Before releases**: Review for accuracy and completeness
- **After issues**: Document solutions in Troubleshooting section

Remember: The badges section should remain intact. Update content below the badges.

## Tools & Resources

### Markdown Validation

```bash
# Check markdown syntax
npm run lint
```

### Badge Services

- Build status: shields.io
- License: choosealicense.com
- Version: img.shields.io

### README Generators

- readme-md-generator
- Standard README

## Related Files & Resources

- [action.yaml](../../../action.yaml) — Action definition (inputs, outputs, steps)
- [CLAUDE.md](../../../CLAUDE.md) — Architecture, conventions, and development guide
- [CHANGELOG.md](../../../CHANGELOG.md) — Version history and release notes
- [LICENSE](../../../LICENSE) — MIT License
- [examples/](../../../examples/) — Sample Terraform configs for testing
- [.github/workflows/](../../../.github/workflows/) — CI/CD workflows
- [.claude/skills/terraform-plan/](../../../.claude/skills/terraform-plan/) — Local CLI skill

## Good README Practices for tf-plan-action

### Do's

✅ Keep badges at the top  
✅ Show real examples that work  
✅ Document each input clearly  
✅ Explain why OIDC is secure (vs API keys)  
✅ Show multi-cloud examples  
✅ Link to CLAUDE.md for architecture  
✅ Keep examples up-to-date with latest version  

### Don'ts

❌ Remove or modify the badges section  
❌ Include outdated version numbers  
❌ Claim features that don't exist yet  
❌ Forget to update when adding inputs  
❌ Use examples with hardcoded secrets  

## Maintenance Schedule

- **After feature PR merge**: Update README in same commit
- **Before release**: Review for accuracy and completeness
- **After user issues**: Add to Troubleshooting section
- **Quarterly**: Check for outdated info or broken links
