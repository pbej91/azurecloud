# Terraform Diff & Deploy Pipeline Guide

## Overview

Two-stage pipeline controlled via PR comments:
1. **Diff Stage** - `terraform: diff: sbx1.eastus` → Shows terraform plan
2. **Deploy Stage** - After manual approval → `terraform: deploy: sbx1.eastus` → Applies changes

## Setup

### 1. Create Environment with Manual Approval

Go to your GitHub repo → Settings → Environments → Create "terraform-approval"

Enable: **Required reviewers** (add approvers)

### 2. GitHub Secrets

Add these secrets to your repo:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `TERRAFORM_BACKEND_ACCESS_KEY`
- `TERRAFORM_BACKEND_RG`
- `TERRAFORM_BACKEND_SA`
- `TERRAFORM_BACKEND_CONTAINER`
- `TERRAFORM_BACKEND_KEY`
- `TERRAFORM_ENV` (dev/staging/prod)

## Usage

### Step 1: Create Pull Request

```bash
git checkout -b feature/add-resources
# Make terraform changes
git commit -m "Add new storage account"
git push origin feature/add-resources
```

Go to GitHub and create a Pull Request.

### Step 2: Request Diff (Plan)

Comment on the PR:
```
terraform: diff: sbx1.eastus
```

**What happens:**
- ✅ Pipeline parses the comment
- ✅ Runs `terraform plan`
- ✅ Posts full diff in PR comment
- ✅ Waits for manual approval

### Step 3: Review & Approve

1. Review the diff posted in PR comment
2. In GitHub Actions tab, approve the `terraform-approval` environment
3. Or reviewers can approve via the "Review pending deployments" link in the workflow

### Step 4: Deploy (Apply)

After approval, comment on the PR:
```
terraform: deploy: sbx1.eastus
```

**What happens:**
- ✅ Pipeline runs `terraform apply`
- ✅ Creates/updates resources in Azure
- ✅ Posts success/failure comment

## Comment Format

### Diff Command
```
terraform: diff: subscription.region
```

Examples:
- `terraform: diff: sbx1.eastus` (Sandbox, East US)
- `terraform: diff: prod.westeurope` (Production, West Europe)
- `terraform: diff: staging.uksouth` (Staging, UK South)

### Deploy Command
```
terraform: deploy: subscription.region
```

Must match the subscription.region from the diff command.

## Complete Example

**PR Comment Timeline:**

```
Comment 1 (by developer):
terraform: diff: sbx1.eastus

[Pipeline runs terraform plan and posts diff]

[Reviewer approves in GitHub]

Comment 2 (by developer):
terraform: deploy: sbx1.eastus

[Pipeline runs terraform apply]
✅ Deployment complete!
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Required environment but not found" | Create `terraform-approval` environment in repo settings |
| Workflow doesn't parse comment | Ensure exact format: `terraform: diff: subscription.region` |
| Azure auth fails | Verify all secrets are set correctly |
| No approval prompt shown | Check environment requires reviewers in settings |

## Workflow Files

- `.github/workflows/terraform-diff.yml` - Handles `terraform: diff:` comments
- `.github/workflows/terraform-deploy.yml` - Handles `terraform: deploy:` comments
