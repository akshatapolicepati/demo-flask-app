# Deployment Runbook

## Purpose

This document provides operational instructions for deploying, validating, troubleshooting, and rolling back the Flask Expense Tracker application.

This runbook is intended for engineers responsible for maintaining the platform.

---

# Prerequisites

## Local Tools

Required tools:

- Git
- Terraform
- Docker
- AWS CLI

Verification:

```bash
terraform version
```

```bash
docker --version
```

```bash
aws --version
```

---

# GitHub Configuration

## Repository Secrets

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

## Repository Variables

```text
AWS_REGION
AWS_ACCOUNT_ID
ECR_REPOSITORY
```

---

# Deployment Process

## Development Deployment

### Create Feature Branch

```bash
git checkout development

git checkout -b feature/my-change
```

### Raise Pull Request

Submit Pull Request:

```text
feature/my-change
        ↓
development
```

### CI Validation

The CI workflow automatically performs:

```text
Terraform Init
Terraform Format Check
Terraform Validate
```

Expected Status:

```text
✅ Passed
```

### Merge

Merge Pull Request after successful review and validation.

### CD Execution

The deployment workflow automatically:

```text
Builds Docker Image
Pushes Image To ECR
Runs Terraform Validate
Generates Terraform Plan
```

Environment:

```text
DEV
```

---

# Promotion Process

## Development → Staging

Create Pull Request:

```text
development
      ↓
staging
```

Environment:

```text
STAGING
```

Terraform Variables:

```text
staging.tfvars
```

---

## Staging → Production

Create Pull Request:

```text
staging
      ↓
main
```

Environment:

```text
PRODUCTION
```

Terraform Variables:

```text
prod.tfvars
```

---

# Verification

## Verify GitHub Actions

Navigate to:

```text
Repository
→ Actions
```

Confirm:

```text
Workflow Successful
```

---

## Verify Docker Image

```bash
aws ecr list-images \
--repository-name flask_app_repo
```

Verify latest image exists.

---

## Verify Infrastructure Plan

Review workflow output.

Expected result:

```text
Terraform Plan generated successfully
```

---

# Rollback Procedure

## Application Rollback

Revert the change:

```bash
git revert <commit-id>
```

Push:

```bash
git push
```

The pipeline will automatically generate a rollback Terraform Plan.

---

## Infrastructure Rollback

Revert the Terraform changes:

```bash
git revert <commit-id>
```

Push:

```bash
git push
```

Review the generated plan.

---

# Troubleshooting

## Terraform Validation Failure

Run:

```bash
terraform fmt -recursive

terraform validate
```

Review validation output.

---

## Docker Build Failure

Verify:

```text
app/Dockerfile
```

exists.

Run locally:

```bash
docker build -t flask_app -f app/Dockerfile app
```

---

## AWS Authentication Failure

Verify the repository secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

are configured and valid.

---

## Terraform Plan Failure

Run locally:

```bash
terraform init

terraform validate

terraform plan \
-var-file=environments/dev.tfvars
```

Review the error output.

---

# Ownership

Primary Maintainer

```text
Akshata Police Pati
```

Repository

```text
FLASK_APP
```

