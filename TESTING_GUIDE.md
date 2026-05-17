# Pipeline Testing Guide

## Prerequisites

1. **GitHub Secrets Setup** - Add these to your repository settings (`Settings > Secrets and variables > Actions`):
   - `AZURE_CLIENT_ID` - Service principal client ID
   - `AZURE_TENANT_ID` - Azure tenant ID
   - `AZURE_SUBSCRIPTION_ID` - Azure subscription ID
   - `TERRAFORM_BACKEND_ACCESS_KEY` - Storage account access key
   - `TERRAFORM_BACKEND_RG` - Backend resource group name
   - `TERRAFORM_BACKEND_SA` - Backend storage account name
   - `TERRAFORM_BACKEND_CONTAINER` - Backend container name
   - `TERRAFORM_BACKEND_KEY` - Backend state file name
   - `TERRAFORM_ENV` - Environment (dev/staging/prod)

2. **Terraform Backend** - Ensure Azure storage backend is configured

## Testing Steps

### Step 1: Create a Feature Branch
```bash
git checkout -b test/resource-group-creation
```

### Step 2: Update terraform.tfvars
Edit `terraform/terraform.tfvars` with your actual values:
```hcl
resource_group_name = "rg-test-deployment"
location             = "East US"
environment          = "dev"
project_name         = "myproject"
subscription_id      = "your-actual-subscription-id"
subscription         = "dev"
region               = "eastus"
```

### Step 3: Commit with Proper Message Format
```bash
git add terraform/
git commit -m "terraform: (dev):eastus

Add sample resource group and storage account for testing"
```

**Important:** The commit message MUST follow the format:
```
terraform: (subscription):region
```

Examples:
- `terraform: (prod):us-east-1`
- `terraform: (staging):westeurope`
- `terraform: (dev):eastus`

### Step 4: Push and Create Pull Request
```bash
git push origin test/resource-group-creation
```

Go to GitHub and create a Pull Request. The pipeline will:
1. ✅ Parse commit message for `(dev):eastus`
2. ✅ Run `terraform plan` with those values
3. ✅ Post diff summary in PR comments
4. ✅ Show resources to be created

### Step 5: Review the Plan
- Check PR comments for the terraform plan diff
- Verify resource group name and storage account will be created
- Review any changes

### Step 6: Merge to Main for Deployment
Once approved, merge the PR to `main` branch.

The pipeline will then:
1. ✅ Parse commit message again
2. ✅ Run `terraform plan` one more time
3. ✅ Run `terraform apply` automatically
4. ✅ Create resource group and storage account in Azure

### Step 7: Verify in Azure
```bash
az group list --query "[?name=='rg-myproject-dev-eastus']"
az storage account list --resource-group rg-myproject-dev-eastus
```

## Expected Results

**Resource Group Created:**
- Name: `rg-myproject-dev-eastus`
- Location: `East US`
- Tags: `Environment=dev`, `Project=myproject`, `Subscription=dev`, `Region=eastus`

**Storage Account Created:**
- Name: `stmyprojectdeveastus` (alphanumeric only)
- Resource Group: `rg-myproject-dev-eastus`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "No terraform target found in commit message" | Ensure commit message matches format: `terraform: (subscription):region` |
| Plan fails with variable error | Check all required variables are in `terraform.tfvars` |
| Azure authentication fails | Verify all secrets are set correctly in GitHub |
| Backend initialization fails | Check backend storage account exists and credentials are correct |

## Clean Up Test Resources
```bash
az group delete --name rg-myproject-dev-eastus --yes
```
