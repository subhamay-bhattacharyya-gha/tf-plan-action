# Migration Guide: S3 to HCP Terraform Cloud

This guide helps you migrate from using S3 backend to HCP Terraform Cloud for state management.

## Prerequisites

1. **HCP Terraform Cloud Account**: Sign up at [app.terraform.io](https://app.terraform.io)
2. **Organization and Workspace**: Create these in the Terraform Cloud UI
3. **API Token**: Generate from User Settings → Tokens

## Step-by-Step Migration

### 1. Backup Your Current State

Before migrating, ensure you have a backup of your current Terraform state:

```bash
# Download current state from S3
aws s3 cp s3://your-bucket/path/to/terraform.tfstate ./terraform.tfstate.backup
```

### 2. Update Your Terraform Configuration

Modify your `main.tf` or `backend.tf` file:

**Before (S3 Backend):**
```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "path/to/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
```

**After (HCP Terraform Cloud):**
```hcl
terraform {
  required_version = ">= 1.0"
  # HCP Terraform Cloud configuration will be injected by the GitHub Action
}
```

### 3. Update Your GitHub Action Workflow

**Before (S3 Backend):**
```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    terraform-dir: tf/
    backend-type: s3
    s3-bucket: ${{ vars.AWS_TF_STATE_BUCKET }}
    s3-region: us-east-1
    tf-vars-file: dev.tfvars
```

**After (HCP Terraform Cloud):**
```yaml
- uses: subhamay-bhattacharyya-gha/tf-plan-action@main
  with:
    terraform-dir: tf/
    backend-type: remote
    tfc-organization: my-org
    tfc-workspace: my-workspace
    tfc-token: ${{ secrets.TFC_API_TOKEN }}
    tf-vars-file: dev.tfvars
```

### 4. Set Up Repository Secrets

Add these secrets to your GitHub repository:

- `TFC_API_TOKEN`: Your Terraform Cloud API token
- `TFC_ORGANIZATION`: Your Terraform Cloud organization name
- `TFC_WORKSPACE`: Your Terraform Cloud workspace name

### 5. Migrate State (Optional)

If you want to migrate existing state from S3 to Terraform Cloud:

1. **Local Migration:**
   ```bash
   # Initialize with old backend
   terraform init
   
   # Change backend configuration to remote
   # Then re-initialize and migrate
   terraform init -migrate-state
   ```

2. **Or Upload State Manually:**
   - Download state from S3
   - Upload to Terraform Cloud via UI or API

### 6. Test the Migration

1. Run your updated GitHub Action workflow
2. Verify that the plan runs successfully
3. Check that state is properly stored in Terraform Cloud

## Benefits of HCP Terraform Cloud

- **Built-in State Locking**: No need for DynamoDB tables
- **State History**: Automatic versioning and history
- **Collaboration**: Team access and permissions
- **Policy as Code**: Sentinel policies for governance
- **Cost Estimation**: Built-in cost estimates for changes
- **VCS Integration**: Direct integration with GitHub/GitLab
- **Remote Execution**: Run plans and applies in Terraform Cloud

## Rollback Plan

If you need to rollback to S3:

1. Change `backend-type` back to `s3` in your workflow
2. Update your Terraform configuration to use S3 backend
3. Run `terraform init -migrate-state` to move state back to S3

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure your TFC_API_TOKEN is valid and has proper permissions
2. **Workspace Not Found**: Verify organization and workspace names are correct
3. **State Lock Issues**: Check if there are any running operations in Terraform Cloud

### Getting Help

- [Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [GitHub Issues](https://github.com/subhamay-bhattacharyya-gha/tf-plan-action/issues)