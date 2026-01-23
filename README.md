# GitHub Action: Terraform Plan

![Release](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/tf-plan-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b78231973ba23bf79edc938aa3c2db5/raw/tf-plan-action.json?)

A comprehensive GitHub composite action for running `terraform plan` with support for multiple backends (S3, HCP Terraform Cloud) and multi-cloud authentication (AWS, GCP, Azure, Snowflake, Databricks) using OIDC/Workload Identity Federation.

---

## 🧩 Features

- **🔄 Multiple Backend Support**: Choose between S3 or HCP Terraform Cloud backends
- **☁️ S3 Backend**: Dynamic key construction based on GitHub repo name with encryption and locking
- **🏢 HCP Terraform Cloud**: Native integration with Terraform Cloud workspaces and remote execution
- **🌐 Multi-Cloud Authentication**: Built-in OIDC support for AWS, GCP, Azure, Snowflake, and Databricks
  - **AWS**: IAM role assumption via OIDC
  - **GCP**: Workload Identity Federation for secure access
  - **Azure**: Service principal authentication via OIDC
  - **Snowflake**: Private key authentication for secure data platform access
  - **Databricks**: Personal access token authentication for unified analytics platform
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
| `cloud-provider`      | Cloud service provider: `aws`, `gcp`, `azure`, `snowflake`, or `databricks` | Yes      | —         |

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

#### Snowflake Authentication (when `cloud-provider` is `snowflake`)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `snowflake-account`   | Snowflake account identifier                             | Yes*     | —         |
| `snowflake-user`      | Snowflake user name                                      | Yes*     | —         |
| `snowflake-role`      | Snowflake role name                                      | Yes*     | —         |
| `snowflake-private-key` | Snowflake private key for authentication (use secrets) | Yes*     | —         |

#### Databricks Authentication (when `cloud-provider` is `databricks`)

| Name                  | Description                                              | Required | Default   |
|-----------------------|----------------------------------------------------------|----------|-----------|
| `databricks-host`     | Databricks workspace URL (use secrets)                   | Yes*     | —         |
| `databricks-token`    | Databricks personal access token (use secrets)           | Yes*     | —         |

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
    cloud-provider: gcp  # or aws, azure, snowflake, databricks
    # Add your cloud-specific authentication inputs
    gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
    gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
    # Add your backend configuration
    backend-type: remote  # or s3
    tfc-token: ${{ secrets.TFC_API_TOKEN }}
```

> **Note:** Always store sensitive values like API tokens, role ARNs, and service account details as GitHub repository secrets. Use repository variables for non-sensitive configuration values like regions and bucket names.

---

## 🚀 Example Usage

### AWS Cloud Provider

#### AWS with S3 Backend

```yaml
name: Terraform Plan - AWS with S3 Backend

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
          s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
          s3-region: ${{ vars.AWS_REGION }}
          cloud-provider: aws
          aws-region: ${{ vars.AWS_REGION }}
          aws-role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          tf-vars-file: dev.tfvars
          ci-pipeline: "true"
```

> **Note:** Configure these values in your GitHub repository:
> - `AWS_REGION` (Variable): Your AWS region (e.g., `us-east-1`)
> - `AWS_TF_STATE_BUCKET` (Variable): Your S3 bucket name for Terraform state (e.g., `my-company-terraform-state`)
> - `AWS_ROLE_ARN` (Secret): Your IAM role ARN (e.g., `arn:aws:iam::123456789012:role/GitHubActionsRole`)
> 
> Never hardcode IAM role ARNs, bucket names, or regions in your workflow files. Store sensitive values like role ARNs as GitHub repository secrets and non-sensitive values like regions and bucket names as repository variables for security.

#### AWS with HCP Terraform Cloud Backend

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
name: Terraform Plan - AWS with HCP Terraform Cloud

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
          cloud-provider: aws
          aws-region: ${{ vars.AWS_REGION }}
          aws-role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `AWS_REGION` (Variable): Your AWS region (e.g., `us-east-1`)
> - `AWS_ROLE_ARN` (Secret): Your IAM role ARN (e.g., `arn:aws:iam::123456789012:role/GitHubActionsRole`)
> 
> Store all authentication tokens and role ARNs as GitHub repository secrets. Configure your backend settings directly in your Terraform files.

### GCP Cloud Provider

#### GCP with S3 Backend

```yaml
name: Terraform Plan - GCP with S3 Backend

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
          s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
          s3-region: ${{ vars.AWS_REGION }}
          cloud-provider: gcp
          gcp-wif-provider: ${{ secrets.GCP_WIF_PROVIDER }}
          gcp-service-account: ${{ secrets.GCP_BOOTSTRAP_SA }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `AWS_TF_STATE_BUCKET` (Variable): Your S3 bucket name for Terraform state (e.g., `my-company-terraform-state`)
> - `AWS_REGION` (Variable): Your AWS region for the S3 backend (e.g., `us-east-1`)
> - `GCP_WIF_PROVIDER` (Secret): Your GCP Workload Identity Federation provider
> - `GCP_BOOTSTRAP_SA` (Secret): Your GCP service account email
> 
> This setup uses AWS S3 for state storage while authenticating to GCP for resource management. Store all authentication credentials as GitHub repository secrets.

#### GCP with HCP Terraform Cloud Backend

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
name: Terraform Plan - GCP with HCP Terraform Cloud

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

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `GCP_WIF_PROVIDER` (Secret): Your GCP Workload Identity Federation provider
> - `GCP_BOOTSTRAP_SA` (Secret): Your GCP service account email
> 
> Store all authentication tokens and provider configurations as GitHub repository secrets for security. Configure your backend settings directly in your Terraform files.

### Azure Cloud Provider

#### Azure with S3 Backend

```yaml
name: Terraform Plan - Azure with S3 Backend

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
          s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
          s3-region: ${{ vars.AWS_REGION }}
          cloud-provider: azure
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `AWS_TF_STATE_BUCKET` (Variable): Your S3 bucket name for Terraform state (e.g., `my-company-terraform-state`)
> - `AWS_REGION` (Variable): Your AWS region for the S3 backend (e.g., `us-east-1`)
> - `AZURE_CLIENT_ID` (Secret): Your Azure application (client) ID
> - `AZURE_TENANT_ID` (Secret): Your Azure directory (tenant) ID
> - `AZURE_SUBSCRIPTION_ID` (Secret): Your Azure subscription ID
> 
> This setup uses AWS S3 for state storage while authenticating to Azure for resource management. Store all authentication credentials as GitHub repository secrets.

#### Azure with HCP Terraform Cloud Backend

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
name: Terraform Plan - Azure with HCP Terraform Cloud

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

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `AZURE_CLIENT_ID` (Secret): Your Azure application (client) ID
> - `AZURE_TENANT_ID` (Secret): Your Azure directory (tenant) ID
> - `AZURE_SUBSCRIPTION_ID` (Secret): Your Azure subscription ID
> 
> Store all authentication tokens and Azure credentials as GitHub repository secrets for security. Configure your backend settings directly in your Terraform files.


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

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `AZURE_CLIENT_ID` (Secret): Your Azure application (client) ID
> - `AZURE_TENANT_ID` (Secret): Your Azure directory (tenant) ID
> - `AZURE_SUBSCRIPTION_ID` (Secret): Your Azure subscription ID
> 
> Store all authentication tokens and Azure credentials as GitHub repository secrets for security. Configure your backend settings directly in your Terraform files.
> **Note:** Configure these Azure secrets in your GitHub repository:
> - `AZURE_CLIENT_ID`: Your Azure application (client) ID
> - `AZURE_TENANT_ID`: Your Azure tenant ID
> - `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
> 
> These values are required for OIDC authentication with Azure and should never be hardcoded in workflow files.

### Snowflake Cloud Provider

#### Snowflake with S3 Backend

```yaml
name: Terraform Plan - Snowflake with S3 Backend

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
          s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
          s3-region: ${{ vars.AWS_REGION }}
          cloud-provider: snowflake
          snowflake-account: ${{ vars.SNOWFLAKE_ACCOUNT }}
          snowflake-user: ${{ vars.SNOWFLAKE_USER }}
          snowflake-role: ${{ vars.SNOWFLAKE_ROLE }}
          snowflake-private-key: ${{ secrets.SNOWFLAKE_PRIVATE_KEY }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `AWS_TF_STATE_BUCKET` (Variable): Your S3 bucket name for Terraform state (e.g., `my-company-terraform-state`)
> - `AWS_REGION` (Variable): Your AWS region for the S3 backend (e.g., `us-east-1`)
> - `SNOWFLAKE_ACCOUNT` (Variable): Your Snowflake account identifier (e.g., `xy12345.us-east-1`)
> - `SNOWFLAKE_USER` (Variable): Your Snowflake user name
> - `SNOWFLAKE_ROLE` (Variable): Your Snowflake role name (e.g., `TERRAFORM_ROLE`)
> - `SNOWFLAKE_PRIVATE_KEY` (Secret): Your Snowflake private key for authentication
> 
> This setup uses AWS S3 for state storage while authenticating to Snowflake for resource management. Store the private key as a GitHub repository secret.

#### Snowflake with HCP Terraform Cloud Backend

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
name: Terraform Plan - Snowflake with HCP Terraform Cloud

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
          cloud-provider: snowflake
          snowflake-account: ${{ vars.SNOWFLAKE_ACCOUNT }}
          snowflake-user: ${{ vars.SNOWFLAKE_USER }}
          snowflake-role: ${{ vars.SNOWFLAKE_ROLE }}
          snowflake-private-key: ${{ secrets.SNOWFLAKE_PRIVATE_KEY }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `SNOWFLAKE_ACCOUNT` (Variable): Your Snowflake account identifier (e.g., `xy12345.us-east-1`)
> - `SNOWFLAKE_USER` (Variable): Your Snowflake user name
> - `SNOWFLAKE_ROLE` (Variable): Your Snowflake role name (e.g., `TERRAFORM_ROLE`)
> - `SNOWFLAKE_PRIVATE_KEY` (Secret): Your Snowflake private key for authentication
> 
> Store all authentication tokens and private keys as GitHub repository secrets for security. Configure your backend settings directly in your Terraform files.

### Databricks Cloud Provider

#### Databricks with S3 Backend

```yaml
name: Terraform Plan - Databricks with S3 Backend

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
          s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
          s3-region: ${{ vars.AWS_REGION }}
          cloud-provider: databricks
          databricks-host: ${{ secrets.DATABRICKS_HOST }}
          databricks-token: ${{ secrets.DATABRICKS_TOKEN }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `AWS_TF_STATE_BUCKET` (Variable): Your S3 bucket name for Terraform state (e.g., `my-company-terraform-state`)
> - `AWS_REGION` (Variable): Your AWS region for the S3 backend (e.g., `us-east-1`)
> - `DATABRICKS_HOST` (Secret): Your Databricks workspace URL (e.g., `https://dbc-12345678-9abc.cloud.databricks.com`)
> - `DATABRICKS_TOKEN` (Secret): Your Databricks personal access token
> 
> This setup uses AWS S3 for state storage while authenticating to Databricks for resource management. Store all Databricks credentials as GitHub repository secrets.

#### Databricks with HCP Terraform Cloud Backend

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
name: Terraform Plan - Databricks with HCP Terraform Cloud

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
          cloud-provider: databricks
          databricks-host: ${{ secrets.DATABRICKS_HOST }}
          databricks-token: ${{ secrets.DATABRICKS_TOKEN }}
          tf-vars-file: production.tfvars
```

> **Note:** Configure these values in your GitHub repository:
> - `TFC_API_TOKEN` (Secret): Your HCP Terraform Cloud API token
> - `DATABRICKS_HOST` (Secret): Your Databricks workspace URL (e.g., `https://dbc-12345678-9abc.cloud.databricks.com`)
> - `DATABRICKS_TOKEN` (Secret): Your Databricks personal access token
> 
> Store all authentication tokens as GitHub repository secrets for security. Configure your backend settings directly in your Terraform files.

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

### Setting up Snowflake Authentication

1. **Generate RSA Key Pair**:
   ```bash
   # Generate private key
   openssl genrsa -out snowflake_key.pem 2048
   
   # Generate public key
   openssl rsa -in snowflake_key.pem -pubout -out snowflake_key.pub
   
   # Get the public key value (remove headers and newlines)
   grep -v "BEGIN PUBLIC" snowflake_key.pub | grep -v "END PUBLIC" | tr -d '\n'
   ```

2. **Configure Snowflake User**:
   ```sql
   -- Assign the public key to your Snowflake user
   ALTER USER <username> SET RSA_PUBLIC_KEY='<public_key_value>';
   
   -- Create a role for Terraform (if not exists)
   CREATE ROLE IF NOT EXISTS TERRAFORM_ROLE;
   
   -- Grant necessary privileges to the role
   GRANT USAGE ON WAREHOUSE <warehouse_name> TO ROLE TERRAFORM_ROLE;
   GRANT CREATE SCHEMA ON DATABASE <database_name> TO ROLE TERRAFORM_ROLE;
   
   -- Assign the role to your user
   GRANT ROLE TERRAFORM_ROLE TO USER <username>;
   ```

3. **Prepare Private Key for GitHub Secret**:
   ```bash
   # Remove headers and format as single line
   grep -v "BEGIN RSA PRIVATE KEY" snowflake_key.pem | \
   grep -v "END RSA PRIVATE KEY" | \
   tr -d '\n'
   ```

4. **Add Repository Secrets and Variables**:
   - `SNOWFLAKE_ACCOUNT` (Variable): Your account identifier (e.g., `xy12345.us-east-1`)
   - `SNOWFLAKE_USER` (Variable): Your Snowflake user name
   - `SNOWFLAKE_ROLE` (Variable): Your Snowflake role name (e.g., `TERRAFORM_ROLE`)
   - `SNOWFLAKE_PRIVATE_KEY` (Secret): Your private key (single line, no headers)

5. **Configure Snowflake Provider in Terraform**:
   ```hcl
   terraform {
     required_providers {
       snowflake = {
         source  = "Snowflake-Labs/snowflake"
         version = "~> 0.90"
       }
     }
   }
   
   provider "snowflake" {
     # Authentication will be provided via environment variables
     # SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER, SNOWFLAKE_ROLE, SNOWFLAKE_PRIVATE_KEY
   }
   ```

### Setting up Databricks Authentication

1. **Generate Personal Access Token**:
   - Log in to your Databricks workspace
   - Click on your username in the top right corner
   - Select **User Settings**
   - Go to the **Access tokens** tab
   - Click **Generate new token**
   - Provide a comment (e.g., "Terraform GitHub Actions")
   - Set an optional lifetime (or leave blank for no expiration)
   - Click **Generate**
   - Copy the token immediately (it won't be shown again)

2. **Get Your Workspace URL**:
   - Your Databricks workspace URL is in the format: `https://dbc-12345678-9abc.cloud.databricks.com`
   - You can find it in your browser's address bar when logged into Databricks

3. **Add Repository Secrets**:
   - `DATABRICKS_HOST` (Secret): Your Databricks workspace URL (e.g., `https://dbc-12345678-9abc.cloud.databricks.com`)
   - `DATABRICKS_TOKEN` (Secret): Your Databricks personal access token

4. **Configure Databricks Provider in Terraform**:
   ```hcl
   terraform {
     required_providers {
       databricks = {
         source  = "databricks/databricks"
         version = "~> 1.0"
       }
     }
   }
   
   provider "databricks" {
     # Authentication will be provided via environment variables
     # DATABRICKS_HOST, DATABRICKS_TOKEN
   }
   ```

5. **Best Practices**:
   - Use service principals instead of personal access tokens for production
   - Rotate tokens regularly
   - Set appropriate token lifetimes
   - Use workspace-level tokens for workspace-specific resources
   - Use account-level tokens for account-level resources

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
- **Cloud Provider**: Must specify one of `aws`, `gcp`, `azure`, `snowflake`, or `databricks` with corresponding authentication setup
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
