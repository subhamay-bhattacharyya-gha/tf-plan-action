# GitHub Action: Terraform Plan

![Release](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b78231973ba23bf79edc938aa3c2db5/raw/tf-plan-action.json?)

A GitHub composite action to run `terraform plan` with support for remote S3 backend, DynamoDB state locking, and artifact upload of the plan file.

---

## 🧩 Features

- Initializes Terraform using S3 as the backend.
- Dynamically constructs the `key` path based on the GitHub repo name.
- Supports commit-SHA-based isolation for CI pipelines.
- Uploads the plan output (`tfplan.out` and `plan.txt`) as artifacts.
- Prints formatted output to the GitHub Actions summary.

---

## 📥 Inputs

| Name              | Description                                              | Required | Default   |
|-------------------|----------------------------------------------------------|----------|-----------|
| `terraform-dir`   | Path to the Terraform configuration directory            | No       | `tf`      |
| `tf-vars-file`    | Optional `.tfvars` file to pass to Terraform plan        | No       | `""`      |
| `s3-bucket`       | S3 bucket used for Terraform remote state                | Yes      | —         |
| `s3-region`       | AWS region for the S3 backend                            | Yes      | —         |
| `dynamodb-table`  | DynamoDB table for state locking                         | Yes      | —         |
| `ci-pipeline`     | Boolean string (`"true"` or `"false"`) for SHA-isolated state | No       | `false`   |

---

## 📤 Outputs

| Name           | Description                      |
|----------------|----------------------------------|
| `plan-status`  | Status of the `terraform plan` step |

---

## 🚀 Example Usage

```yaml
name: Terraform Plan

on:
  workflow_dispatch:

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    steps:
      - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
        with:
          terraform-dir: tf/
          tf-vars-file: dev.tfvars
          s3-bucket: my-terraform-state-bucket
          s3-region: us-east-1
          dynamodb-table: terraform-lock-table
          ci-pipeline: "true"
```

---

## 🪪 License

MIT
