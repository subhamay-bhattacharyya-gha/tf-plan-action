---
name: terraform-plan
description: Execute terraform plan with cloud authentication, validation, and artifact management
user-invocable: true
metadata:
  category: project-specific
  tags: [terraform, infrastructure, plan, aws, gcp, azure, backend, validation, oidc]
---


# Terraform Plan

Execute a `terraform plan` with the same validation, authentication, and artifact handling as the tf-plan-action GitHub Composite Action. Supports S3 and HCP Terraform Cloud backends across AWS, GCP, Azure, Snowflake, and Databricks cloud providers.

## When to use this skill

- Running `terraform plan` locally with automatic cloud authentication (OIDC or API tokens)
- Validating Terraform configuration before committing or deploying
- Generating plan artifacts (binary and JSON) for review or downstream processing
- Testing multi-cloud infrastructure with consistent input validation
- Dry-running Terraform changes with detailed resource change summaries

## Your process

### 1. Gather and validate inputs

First, ask the user or infer from the current environment:
- **Backend type**: `s3` (AWS S3) or `remote` (HCP Terraform Cloud) — defaults to `s3`
- **Cloud provider**: `aws`, `gcp`, `azure`, `snowflake`, `databricks`, or `platform` (auto-detect)
- **Terraform config path**: relative path to Terraform directory — defaults to `tf/`
- **Release tag**: Git tag to check out (optional)
- **CI pipeline mode**: set to `true` to include commit SHA in S3 state key — defaults to `false`

Then validate required inputs based on the chosen backend and cloud provider:

#### S3 backend validation
- Require: `s3-bucket`, `s3-region`
- Optional: `s3-key-prefix`, `ci-pipeline`

#### Remote (HCP Terraform Cloud) backend validation
- Require: `tfc-token` (API token)

#### Cloud provider validation
- **AWS**: Require `aws-region` and `aws-role-to-assume` (IAM role ARN for OIDC)
- **GCP**: Require `gcp-wif-provider` and `gcp-service-account`
- **Azure**: Require `azure-client-id`, `azure-tenant-id`, `azure-subscription-id`
- **Snowflake**: Expect auth via environment variables (`SNOWFLAKE_PRIVATE_KEY`, `SNOWFLAKE_ORGANIZATION_NAME`, `SNOWFLAKE_ACCOUNT_NAME`, `SNOWFLAKE_USER`, `SNOWFLAKE_ROLE`)
- **Databricks**: Expect auth via environment variables (`DATABRICKS_HOST`, `DATABRICKS_TOKEN`)
- **Platform** (auto-detect): Check for `infra/aws`, `infra/gcp`, `infra/azure`, `infra/snowflake`, `infra/databricks` directories and validate inputs only for the clouds found

If any required input is missing, halt with a clear error message listing what is required.

### 2. Set up the environment

1. **Optional checkout**: If `release-tag` is provided, check out that tag; otherwise use the current working directory.
2. **Install Terraform**: Ensure Terraform is installed and available in PATH (version 1.0+). Suggest `brew install terraform` or equivalent if missing.
3. **Verify TF config**: Check that `tf-config-path` exists and contains `.tf` files.

### 3. Authenticate with the cloud provider

Based on `cloud-provider`, guide the user through the appropriate authentication flow:

#### AWS (OIDC)
- If running in GitHub Actions, OIDC federation is automatic
- If running locally, guide the user to assume the IAM role manually:
  ```bash
  aws sts assume-role --role-arn <aws-role-to-assume> --role-session-name terraform-plan --region <aws-region>
  ```
  Then export the temporary credentials to the environment.
- Alternatively, guide the user to use existing AWS CLI credentials (e.g., from `~/.aws/credentials`)

#### GCP (Workload Identity Federation)
- If running in GitHub Actions, WIF is automatic
- If running locally, guide the user to authenticate with `gcloud`:
  ```bash
  gcloud auth login
  gcloud config set project <gcp-project>
  ```
- Or use a service account key and set `GOOGLE_APPLICATION_CREDENTIALS`

#### Azure (Service Principal)
- If running in GitHub Actions, OIDC is automatic
- If running locally, guide the user to:
  ```bash
  az login --service-principal -u <azure-client-id> -p <password> --tenant <azure-tenant-id>
  az account set --subscription <azure-subscription-id>
  ```

#### Snowflake / Databricks
- These require environment variables set by the calling workflow or user
- Confirm with the user that the required environment variables are set before proceeding

### 4. Initialize the Terraform backend

#### S3 backend init
1. Generate the S3 state key: `{repo-name}/terraform.tfstate` or `{repo-name}/{commit-sha}/terraform.tfstate` (if `ci-pipeline == true`)
2. Run: 
   ```bash
   cd <tf-config-path>
   terraform init -input=false \
     -backend-config="bucket=<s3-bucket>" \
     -backend-config="key=<s3-key>" \
     -backend-config="region=<s3-region>" \
     -backend-config="encrypt=true" \
     -backend-config="use_lockfile=true"
   ```
3. Capture any errors and report them clearly

#### Remote (HCP Terraform Cloud) backend init
1. Create `~/.terraform.d/credentials.tfrc.json`:
   ```json
   {
     "credentials": {
       "app.terraform.io": {
         "token": "<tfc-token>"
       }
     }
   }
   ```
2. Run:
   ```bash
   cd <tf-config-path>
   terraform init -input=false
   ```
3. Capture the run URL if available (log grep for `https://app.terraform.io/app/.../runs/run-...`)
4. Clean up credentials file after completion (in step 6)

### 5. Run `terraform plan`

1. Run:
   ```bash
   cd <tf-config-path>
   terraform plan -input=false -out=tfplan.binary [-var-file=<tf-vars-file>]
   ```
   - If `verbose-plan-output == true`, stream full output to the user
   - Otherwise, log to a file and only show errors or summary
2. Capture the binary plan file: `tfplan.binary`
3. Halt if terraform plan fails

### 6. Generate plan artifacts and summary

1. Export the binary plan as JSON:
   ```bash
   terraform show -json tfplan.binary > tfplan.json
   ```
2. Parse the JSON to extract resource changes:
   - Count resources to add, update, delete, replace, no-op
   - Extract HCP Terraform Cloud run URL if present (backend-type == remote)
3. Build a markdown summary:
   ```
   ## 📋 Terraform Plan Summary — <cloud-provider>
   
   🔗 [View full plan in HCP Terraform](<run-url>)  [if run-url is available]
   
   | Action     | Count   |
   |------------|---------|
   | ➕ Create   | <n>     |
   | 🔄 Update   | <n>     |
   | ❌ Delete   | <n>     |
   | ♻️  Replace  | <n>     |
   | ⏸️  No-op    | <n>     |
   ```
4. Present the summary to the user

### 7. Clean up

1. If `backend-type == remote`, remove the TFC credentials file:
   ```bash
   rm -f ~/.terraform.d/credentials.tfrc.json
   ```
2. Report the location of generated artifacts:
   - Binary plan: `<tf-config-path>/tfplan.binary`
   - JSON plan: `<tf-config-path>/tfplan.json`
   - Log: `<tf-config-path>/plan.log`

## Outputs

After successful completion, report:
- **plan-status**: Success or failure
- **plan-binary-path**: Path to `tfplan.binary`
- **plan-json-path**: Path to `tfplan.json`
- **run-url**: HCP Terraform Cloud run URL (if remote backend)
- **resources-to-add**: Count of resources to add
- **resources-to-change**: Count of resources to update
- **resources-to-destroy**: Count of resources to delete
- **plan-summary**: One-line summary (e.g., "3 to add, 2 to change, 1 to destroy")

## Examples

### Example 1: S3 backend + AWS provider
```
Backend: s3
Cloud Provider: aws
S3 Bucket: my-terraform-state
S3 Region: us-east-1
AWS Region: us-east-1
AWS Role ARN: arn:aws:iam::123456789012:role/terraform-role
```

### Example 2: HCP Terraform Cloud + GCP
```
Backend: remote
Cloud Provider: gcp
TFC Token: <api-token>
GCP WIF Provider: projects/123456/locations/global/workloadIdentityPools/.../providers/...
GCP Service Account: terraform@my-project.iam.gserviceaccount.com
```

### Example 3: Platform mode (auto-detect)
```
Cloud Provider: platform  [auto-detects infra/aws, infra/gcp, infra/azure, ...]
Backend: s3
S3 Bucket: my-state-bucket
S3 Region: us-east-1
AWS Role ARN: arn:aws:iam::123456789012:role/terraform-role
AWS Region: us-east-1
GCP WIF Provider: projects/123456/locations/global/workloadIdentityPools/.../providers/...
GCP Service Account: terraform@my-project.iam.gserviceaccount.com
Azure Client ID: <client-id>
Azure Tenant ID: <tenant-id>
Azure Subscription ID: <subscription-id>
```
