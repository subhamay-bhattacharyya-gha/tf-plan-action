# GitHub Action: Terraform Plan

![Release](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b78231973ba23bf79edc938aa3c2db5/raw/tf-plan-action.json?)

A comprehensive GitHub composite action for running `terraform plan` with support for multiple backends (S3, HCP Terraform Cloud) and multi-cloud authentication (AWS, GCP, Azure) using OIDC/Workload Identity Federation.

---

## 🧩 Features

- **🔄 Multiple Backend Support**: Choose between S3 or HCP Terraform Cloud backends
- **☁️ S3 Backend**: Dynamic key construction based on GitHub repo name with encryption and locking
- **🏢 HCP Terraform Cloud**: Native integration with Terraform Cloud workspaces and remote execution
- **🌐 Multi-Cloud Authentication**: Built-in OIDC support for AWS, GCP, and Azure
  - **AWS**: IAM role assumption via OIDC
  - **GCP**: Workload Identity Federation for secure access
  - **Azure**: Service principal authentication via OIDC
- **� CI/CD Oyptimized**: Commit-SHA-based state isolation for parallel pipeline execution
- **📦 Artifact Management**: Automatic upload of plan files (`tfplan.out` and `plan.txt`) as GitHub artifacts
- **📊 Rich Output**: Formatted Terraform plan output in GitHub Actions summary with syntax highlighting
- **🔒 Security First**: Keyless authentication with automatic credential cleanup
- **⚡ Performance**: Optimized initialization and execution flow
- **🔧 Flexible Configuration**: Support for custom variables, multiple environments, and advanced workflows

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

### Cloud Provider Authentication Inputs

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `cloud-provider`      | Cloud service provider: `aws`, `gcp`, or `azure`         | Yes      | —         |

#### AWS Authentication (when `cloud-provider` is `aws`)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `aws-region`          | AWS region for authentication                            | Yes*     | —         |
| `aws-role-to-assume`  | AWS IAM role ARN to assume                               | Yes*     | —         |

#### GCP Authentication (when `cloud-provider` is `gcp`)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `gcp-wif-provider`    | GCP Workload Identity Federation provider                | Yes*     | —         |
| `gcp-service-account` | GCP service account email for authentication             | Yes*     | —         |

#### Azure Authentication (when `cloud-provider` is `azure`)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `azure-client-id`     | Azure client ID for authentication                       | Yes*     | —         |
| `azure-tenant-id`     | Azure tenant ID for authentication                       | Yes*     | —         |
| `azure-subscription-id` | Azure subscription ID for authentication               | Yes*     | —         |

**Note**: *Required only when the corresponding cloud provider is selected.

---

## 📤 Outputs

| Name           | Description                      |
|----------------|----------------------------------|
| `plan-status`  | Status of the `terraform plan` step |

---

## 🚀 Quick Start

1. **Choose your cloud provider** and set up authentication (see [Setup Guides](#️-setup-guides))
2. **Configure your Terraform backend** (S3 or HCP Terraform Cloud)
3. **Add the action to your workflow**:

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    cloud-provider: gcp  # or aws, azure
    # Add your cloud-specific authentication inputs
    gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
    gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
    # Add your backend configuration
    backend-type: remote  # or s3
    tfc-token: ${{ secrets.TFC_API_TOKEN }}
```

---

## 🚀 Example Usage

### Using S3 Backend with AWS Authentication

```yaml
name: Terraform Plan with S3 Backend

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
          terraform-dir: tf/
          backend-type: s3
          s3-bucket: my-terraform-state-bucket
          s3-region: ${{ secrets.AWS_REGION}}
          cloud-provider: aws
          aws-region: ${{ secrets.AWS_REGION}}
          aws-role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          tf-vars-file: dev.tfvars
          ci-pipeline: "true"
```

### Using HCP Terraform Cloud with GCP Authentication

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
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
        with:
          terraform-dir: infrastructure/
          backend-type: remote
          tfc-token: ${{ secrets.TFC_API_TOKEN }}
          cloud-provider: gcp
          gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
          gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
          tf-vars-file: production.tfvars
```

### Using with Cloud Provider Authentication

#### AWS Authentication

```yaml
name: Terraform Plan with AWS Authentication

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
          backend-type: s3
          s3-bucket: my-terraform-state-bucket
          s3-region: ${{ secrets.AWS_REGION}}
          cloud-provider: aws
          aws-region: ${{ secrets.AWS_REGION}}
          aws-role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          tf-vars-file: production.tfvars
```
> **Note:** Configure these AWS secrets in your GitHub repository:
> - `AWS_REGION`: Your AWS region (e.g., `us-east-1`)
> - `AWS_ROLE_ARN`: Your IAM role ARN (e.g., `arn:aws:iam::123456789012:role/GitHubActionsRole`)
> 
> Never hardcode IAM role ARNs or regions in your workflow files. Always store sensitive values as GitHub repository secrets for security.

#### GCP Authentication

```yaml
name: Terraform Plan with GCP Authentication

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
          cloud-provider: gcp
          gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
          gcp-service-account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
          tf-vars-file: production.tfvars
```
> **Note:** Configure these GCP secrets in your GitHub repository:
> - `GCP_WIF_PROVIDER`: Your Workload Identity Federation provider (e.g., `projects/123456789/locations/global/workloadIdentityPools/my-pool/providers/my-provider`)
> - `GCP_SERVICE_ACCOUNT`: Your service account email (e.g., `my-service-account@my-project.iam.gserviceaccount.com`)
> 
> These values are required for OIDC authentication with Google Cloud and should be stored securely as repository secrets.


#### Azure Authentication

```yaml
name: Terraform Plan with Azure Authentication

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
          cloud-provider: azure
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          tf-vars-file: production.tfvars
```
> **Note:** Configure these Azure secrets in your GitHub repository:
> - `AZURE_CLIENT_ID`: Your Azure application (client) ID
> - `AZURE_TENANT_ID`: Your Azure tenant ID
> - `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
> 
> These values are required for OIDC authentication with Azure and should never be hardcoded in workflow files.

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

### Setting up AWS OIDC Authentication

1. **Create an OIDC Identity Provider**:
   ```bash
   aws iam create-open-id-connect-provider \
     --url https://token.actions.githubusercontent.com \
     --client-id-list sts.amazonaws.com \
     --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
   ```

2. **Create an IAM Role**:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
           "StringEquals": {
             "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
             "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:ref:refs/heads/main"
           }
         }
       }
     ]
   }
   ```

3. **Add Repository Secret**:
   - `AWS_ROLE_ARN`: `arn:aws:iam::ACCOUNT_ID:role/GitHubActionsRole`

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

### Setting up Azure OIDC Authentication

1. **Create an Azure AD Application**:
   ```bash
   az ad app create --display-name "GitHub Actions App"
   ```

2. **Create a Service Principal**:
   ```bash
   az ad sp create --id <APPLICATION_ID>
   ```

3. **Configure Federated Credentials**:
   ```bash
   az ad app federated-credential create \
     --id <APPLICATION_ID> \
     --parameters '{
       "name": "GitHubActions",
       "issuer": "https://token.actions.githubusercontent.com",
       "subject": "repo:your-org/your-repo:ref:refs/heads/main",
       "audiences": ["api://AzureADTokenExchange"]
     }'
   ```

4. **Assign Role to Service Principal**:
   ```bash
   az role assignment create \
     --assignee <SERVICE_PRINCIPAL_ID> \
     --role Contributor \
     --scope /subscriptions/<SUBSCRIPTION_ID>
   ```

5. **Add Repository Secrets**:
   - `AZURE_CLIENT_ID`: Application (client) ID
   - `AZURE_TENANT_ID`: Directory (tenant) ID  
   - `AZURE_SUBSCRIPTION_ID`: Subscription ID

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
    cloud-provider: gcp
    gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
    gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
    tf-vars-file: environments/production.tfvars
```

### CI/CD Pipeline Isolation

Enable commit-SHA-based state isolation for parallel builds:

```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    cloud-provider: aws
    aws-region: us-east-1
    aws-role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    ci-pipeline: "true"  # Creates unique state keys per commit
```

### Multi-Environment Workflows

```yaml
strategy:
  matrix:
    environment: [dev, staging, prod]
    cloud: [aws, gcp, azure]
steps:
  - uses: subhamay-bhattacharyya-gha/tf-plan-action@main
    with:
      terraform-dir: environments/${{ matrix.environment }}
      cloud-provider: ${{ matrix.cloud }}
      tf-vars-file: ${{ matrix.environment }}.tfvars
      # Add cloud-specific authentication inputs based on matrix.cloud
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
- **Permissions**: `contents: read`, `id-token: write` (required for OIDC authentication)
- **Cloud Provider**: Must specify one of `aws`, `gcp`, or `azure` with corresponding authentication setup
- **Backend Configuration**: Either S3 bucket setup or HCP Terraform Cloud workspace configuration

## 🔗 Related Actions

- [hashicorp/setup-terraform](https://github.com/hashicorp/setup-terraform) - Set up Terraform CLI
- [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials) - AWS authentication
- [google-github-actions/auth](https://github.com/google-github-actions/auth) - GCP authentication
- [azure/login](https://github.com/azure/login) - Azure authentication
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
