# GitHub Action: Terraform Plan

![Release](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b78231973ba23bf79edc938aa3c2db5/raw/tf-plan-action.json?)

A comprehensive GitHub composite action for running `terraform plan` with support for multiple backends (S3, HCP Terraform Cloud), GCP Workload Identity Federation, and automated artifact management.

---

## 🧩 Features

- **🔄 Multiple Backend Support**: Choose between S3 or HCP Terraform Cloud backends
- **☁️ S3 Backend**: Dynamic key construction based on GitHub repo name with encryption and locking
- **🏢 HCP Terraform Cloud**: Native integration with Terraform Cloud workspaces and remote execution
- **🔐 GCP Authentication**: Built-in Workload Identity Federation support for secure GCP access
- **🚀 CI/CD Optimized**: Commit-SHA-based state isolation for parallel pipeline execution
- **📦 Artifact Management**: Automatic upload of plan files (`tfplan.out` and `plan.txt`) as GitHub artifacts
- **📊 Rich Output**: Formatted Terraform plan output in GitHub Actions summary with syntax highlighting
- **🔒 Security First**: Secure credential handling with automatic cleanup
- **⚡ Performance**: Optimized initialization and execution flow

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

### HCP Terraform Cloud Inputs (when `backend-type` is `remote`)

| Name              | Description                                              | Required | Default   |
|-------------------|----------------------------------------------------------|----------|-----------|
| `tfc-token`       | HCP Terraform Cloud API token (use secrets)              | Yes      | —         |

**Note**: Backend configuration (organization and workspace) should be defined in your Terraform files.

### GCP Authentication Inputs (optional)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `gcp-wif-provider`    | GCP Workload Identity Federation provider                | No       | —         |
| `gcp-service-account` | GCP service account email for authentication            | No       | —         |

**Note**: Both GCP inputs must be provided together for GCP authentication to be configured.

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

Configure your backend in your Terraform files (e.g., `backend.tf` or `main.tf`):

```hcl
terraform {
  cloud {
    organization = "your-organization"
    workspaces {
      name = "your-workspace"
    }
  }
}
```

Then use the action:

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
          tfc-token: ${{ secrets.TFC_API_TOKEN }}
          tf-vars-file: production.tfvars
```

### Using with GCP Authentication

For GCP resources, you can include Workload Identity Federation authentication:

```yaml
name: Terraform Plan with HCP Terraform Cloud and GCP

on:
  workflow_dispatch:

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
        with:
          terraform-dir: infrastructure/
          backend-type: remote
          tfc-token: ${{ secrets.TFC_API_TOKEN }}
          gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
          gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
          tf-vars-file: production.tfvars
```

## ⚙️ Setup Guides

### Setting up HCP Terraform Cloud

1. **Create a Terraform Cloud Account**: Sign up at [app.terraform.io](https://app.terraform.io)
2. **Create an Organization and Workspace**: Set up your organization and workspace in the Terraform Cloud UI
3. **Generate API Token**: 
   - Go to User Settings → Tokens
   - Create a new API token
   - Add it as a repository secret named `TFC_API_TOKEN`
4. **Configure Your Terraform Code**: Define your backend configuration in your Terraform files:

```hcl
terraform {
  required_version = ">= 1.0"
  
  cloud {
    organization = "your-organization"
    workspaces {
      name = "your-workspace"
    }
  }
}
```

### Setting up GCP Workload Identity Federation

1. **Create a Workload Identity Pool**:
   ```bash
   gcloud iam workload-identity-pools create "github-pool" \
     --project="your-project-id" \
     --location="global" \
     --display-name="GitHub Actions Pool"
   ```

2. **Create a Workload Identity Provider**:
   ```bash
   gcloud iam workload-identity-pools providers create-oidc "github-provider" \
     --project="your-project-id" \
     --location="global" \
     --workload-identity-pool="github-pool" \
     --display-name="GitHub Actions Provider" \
     --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
     --issuer-uri="https://token.actions.githubusercontent.com"
   ```

3. **Create a Service Account and Bind IAM Policy**:
   ```bash
   # Create service account
   gcloud iam service-accounts create github-actions-sa \
     --display-name="GitHub Actions Service Account"

   # Bind the service account to the workload identity pool
   gcloud iam service-accounts add-iam-policy-binding \
     --project="your-project-id" \
     --role="roles/iam.workloadIdentityUser" \
     --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/your-org/your-repo" \
     github-actions-sa@your-project-id.iam.gserviceaccount.com
   ```

4. **Add Repository Secrets**:
   - `GCP_WIF_PROVIDER`: `projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
   - `GCP_BOOTSTRAP_SA`: `github-actions-sa@your-project-id.iam.gserviceaccount.com`

### Setting up S3 Backend

1. **Create S3 Bucket**:
   ```bash
   aws s3 mb s3://your-terraform-state-bucket --region us-east-1
   ```

2. **Enable Versioning and Encryption**:
   ```bash
   aws s3api put-bucket-versioning \
     --bucket your-terraform-state-bucket \
     --versioning-configuration Status=Enabled

   aws s3api put-bucket-encryption \
     --bucket your-terraform-state-bucket \
     --server-side-encryption-configuration '{
       "Rules": [{
         "ApplyServerSideEncryptionByDefault": {
           "SSEAlgorithm": "AES256"
         }
       }]
     }'
   ```

3. **Configure AWS Credentials**: Set up AWS credentials in your GitHub repository secrets or use IAM roles for GitHub Actions.

## 📁 Examples

This repository includes example configurations in the `examples/` directory:

- **`examples/s3-backend/`**: Example Terraform configuration for S3 backend
- **`examples/tfc-backend/`**: Example Terraform configuration for HCP Terraform Cloud backend

You can also find a complete workflow example in `.github/workflows/example.yml` that demonstrates both backend types.

## 🔄 Migration Guide

Migrating from S3 to HCP Terraform Cloud? Check out our [Migration Guide](MIGRATION.md) for step-by-step instructions.

## 🛠️ Advanced Usage

### Custom Terraform Variables

You can pass custom variables using a `.tfvars` file:

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    tf-vars-file: environments/production.tfvars
```

### CI/CD Pipeline Isolation

Enable commit-SHA-based state isolation for parallel builds:

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    ci-pipeline: "true"  # Creates unique state keys per commit
```

### Multi-Environment Workflows

```yaml
strategy:
  matrix:
    environment: [dev, staging, prod]
steps:
  - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
    with:
      terraform-dir: environments/${{ matrix.environment }}
      tf-vars-file: ${{ matrix.environment }}.tfvars
```

## 🔍 Troubleshooting

### Common Issues

**Authentication Errors with HCP Terraform Cloud:**
- Verify your `TFC_API_TOKEN` is valid and has proper permissions
- Ensure your organization and workspace names are correct in your Terraform configuration

**GCP Authentication Failures:**
- Check that Workload Identity Federation is properly configured
- Verify the service account has necessary permissions for your resources
- Ensure repository secrets are correctly set

**S3 Backend Issues:**
- Confirm S3 bucket exists and is accessible
- Verify AWS credentials have proper permissions
- Check bucket region matches the specified region

### Debug Mode

Enable verbose logging by setting environment variables in your workflow:

```yaml
env:
  TF_LOG: DEBUG
  ACTIONS_STEP_DEBUG: true
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the example workflows
5. Submit a pull request

## 📋 Requirements

- **Terraform**: >= 1.0
- **GitHub Actions Runner**: ubuntu-latest, windows-latest, or macos-latest
- **Permissions**: `contents: read`, `id-token: write` (for GCP WIF)

## 🔗 Related Actions

- [hashicorp/setup-terraform](https://github.com/hashicorp/setup-terraform) - Set up Terraform CLI
- [google-github-actions/auth](https://github.com/google-github-actions/auth) - GCP authentication
- [actions/upload-artifact](https://github.com/actions/upload-artifact) - Artifact management

## 📊 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

---

## 🪪 License

MIT License - see [LICENSE](LICENSE) for details.

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/discussions)
- 📖 **Documentation**: [Wiki](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/wiki)
