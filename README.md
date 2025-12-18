# GitHub Action: Terraform Plan

![Release](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b78231973ba23bf79edc938aa3c2db5/raw/tf-plan-action.json?)

A GitHub composite action to run `terraform plan` with support for S3 backend, HCP Terraform Cloud, and artifact upload of the plan file.

---

## 🧩 Features

- **Multiple Backend Support**: Choose between S3 or HCP Terraform Cloud backends.
- **S3 Backend**: Initializes Terraform using S3 with dynamic key construction based on GitHub repo name.
- **HCP Terraform Cloud**: Seamless integration with Terraform Cloud workspaces.
- **CI/CD Optimized**: Supports commit-SHA-based isolation for CI pipelines.
- **Artifact Management**: Uploads plan output (`tfplan.out` and `plan.txt`) as artifacts.
- **Rich Output**: Prints formatted output to the GitHub Actions summary.

---

## 📥 Inputs

### Common Inputs

| Name              | Description                                              | Required | Default   |
|-------------------|----------------------------------------------------------|----------|-----------|
| `terraform-dir`   | Path to the Terraform configuration directory            | No       | `tf`      |
| `release-tag`     | Git release tag to check out                             | No       | `""`      |
| `ci-pipeline`     | Boolean string (`"true"` or `"false"`) for SHA-isolated state | No       | `false`   |
| `backend-type`    | Backend type: `s3` or `remote` (HCP Terraform Cloud)     | No       | `s3`      |
| `tf-plan-name`    | Name of the Terraform plan file                          | No       | `terraform-plan` |
| `tf-plan-file`    | File to save the Terraform plan output                   | No       | `tfplan`  |
| `tf-vars-file`    | Optional Terraform variable file                         | No       | `terraform.tfvars` |

### S3 Backend Inputs (required when `backend-type` is `s3`)

| Name              | Description                                              | Required | Default   |
|-------------------|----------------------------------------------------------|----------|-----------|
| `s3-bucket`       | S3 bucket used for Terraform remote state                | Yes*     | —         |
| `s3-region`       | AWS region for the S3 backend                            | Yes*     | —         |

### HCP Terraform Cloud Inputs (required when `backend-type` is `remote`)

| Name              | Description                                              | Required | Default   |
|-------------------|----------------------------------------------------------|----------|-----------|
| `tfc-organization`| HCP Terraform Cloud organization name                    | Yes*     | —         |
| `tfc-workspace`   | HCP Terraform Cloud workspace name                       | Yes*     | —         |
| `tfc-token`       | HCP Terraform Cloud API token (use secrets)              | Yes*     | —         |

*Required only when the corresponding backend type is selected.

---

## 📤 Outputs

| Name           | Description                      |
|----------------|----------------------------------|
| `plan-status`  | Status of the `terraform plan` step |

---

## 🚀 Example Usage

### Using S3 Backend

```yaml
name: Terraform Plan with S3

on:
  workflow_dispatch:

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    steps:
      - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
        with:
          terraform-dir: tf/
          backend-type: s3
          s3-bucket: my-terraform-state-bucket
          s3-region: us-east-1
          tf-vars-file: dev.tfvars
          ci-pipeline: "true"
```

### Using HCP Terraform Cloud

```yaml
name: Terraform Plan with HCP Terraform Cloud

on:
  workflow_dispatch:

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    steps:
      - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
        with:
          terraform-dir: infrastructure/
          backend-type: remote
          tfc-organization: my-org
          tfc-workspace: my-workspace
          tfc-token: ${{ secrets.TFC_API_TOKEN }}
          tf-vars-file: production.tfvars
```

### Setting up HCP Terraform Cloud

1. **Create a Terraform Cloud Account**: Sign up at [app.terraform.io](https://app.terraform.io)
2. **Create an Organization and Workspace**: Set up your organization and workspace in the Terraform Cloud UI
3. **Generate API Token**: 
   - Go to User Settings → Tokens
   - Create a new API token
   - Add it as a repository secret named `TFC_API_TOKEN`
4. **Configure Your Terraform Code**: Ensure your Terraform configuration includes a `terraform` block with the `remote` backend:

```hcl
terraform {
  backend "remote" {
    # Configuration will be provided by the action
  }
}
```

## 📁 Examples

This repository includes example configurations in the `examples/` directory:

- **`examples/s3-backend/`**: Example Terraform configuration for S3 backend
- **`examples/tfc-backend/`**: Example Terraform configuration for HCP Terraform Cloud backend

You can also find a complete workflow example in `.github/workflows/example.yml` that demonstrates both backend types.

## 🔄 Migration Guide

Migrating from S3 to HCP Terraform Cloud? Check out our [Migration Guide](MIGRATION.md) for step-by-step instructions.

---

## 🪪 License

MIT
