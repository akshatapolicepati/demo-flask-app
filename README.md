# Flask Expense Tracker - Infrastructure Automation with Terraform and GitHub Actions

## Introduction

This repository contains the infrastructure and deployment automation for a containerized Flask-based Expense Tracker application running on AWS.

The objective of vpc-tf project is to demonstrate:

- Infrastructure as Code using Terraform
- Modular Terraform design
- Multi-environment deployment strategy
- CI/CD implementation using GitHub Actions
- Automated Docker image management
- Infrastructure validation and planning

The solution is intentionally designed as a reusable platform that supports development, staging, and production environments using the same codebase.

---

# Application Overview

The application is a lightweight Flask REST API used for managing expense records.

Example operations include:

- Creating expenses
- Retrieving expenses
- Updating expenses
- Health checks

I selected vpc-tf application because it provides a realistic business use case while remaining simple enough to focus on infrastructure automation, deployment pipelines, and architectural decisions.

---

# Architecture

## High-Level Design

```text
                    Internet
                        |
                        v
           Application Load Balancer
                        |
                        v
              ECS Service (Fargate)
                        |
                        v
       Flask Expense Tracker Container
                        |
                        v
                CloudWatch Logs
```

---

## AWS Components

### Networking

- VPC
- Public Subnets
- Internet Gateway
- Route Tables

### Load Balancing

- Application Load Balancer
- Listener
- Target Group
- Health Checks

### Compute

- ECS Cluster
- ECS Service
- ECS Task Definition
- Fargate Launch Type

### Container Registry

- Amazon ECR

### Monitoring

- CloudWatch Logs

---

# Repository Structure

```text
.
├── app/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── application_code
│
├── terraform/
│   ├── environments/
│   │   ├── dev.tfvars
│   │   ├── staging.tfvars
│   │   └── prod.tfvars
│   │
│   ├── modules/
│   │   ├── networking/
│   │   ├── alb/
│   │   └── ecs/
│   │
│   ├── main.tf
│   ├── variables.tf
│   ├── providers.tf
│   ├── locals.tf
│   └── outputs.tf
│
└── .github/
    └── workflows/
        ├── CI-Validation.yml
        └── CD-Plan.yml
```

---

# Terraform Design

Terraform is organized into reusable modules.

## Networking Module

Responsible for:

- VPC creation
- Subnet creation
- Routing configuration

## ALB Module

Responsible for:

- Load balancer
- Listener
- Target group
- Health checks

## ECS Module

Responsible for:

- ECS cluster
- ECS service
- ECS task definition
- CloudWatch log configuration

This structure allows infrastructure components to be maintained independently and reused across environments.

---

# Environment Strategy

The same Terraform codebase is reused across all environments.

Environment-specific values are maintained in separate tfvars files.

| Environment | Branch | Terraform Variables |
|------------|---------|--------------------|
| Development | development | dev.tfvars |
| Staging | staging | staging.tfvars |
| Production | main | prod.tfvars |

This approach simplifies maintenance and reduces configuration drift between environments.

---

# Git Branching Strategy

The deployment workflow follows a promotion-based model.

```text
feature/*
      │
      ▼
development
      │
      ▼
staging
      │
      ▼
main
```

### Feature Development

Developers work in feature branches and submit Pull Requests into the development branch.

### Development

Used for integration testing and validating infrastructure changes.

### Staging

Used for pre-production validation.

### Production

Represents the production-ready codebase.

---

# CI/CD Pipeline

## Continuous Integration

Trigger:

```text
Pull Request
```

Target Branches:

```text
development
staging
main
```

Workflow Steps:

```text
Checkout Code
↓
Terraform Init
↓
Terraform Format Check
↓
Terraform Validate
```

Purpose:

- Catch Terraform issues early
- Validate infrastructure code quality
- Prevent misconfigured infrastructure from reaching shared branches

---

## Continuous Delivery

Trigger:

```text
Merge / Push
```

Branches:

```text
development
staging
main
```

Workflow Steps:

```text
Checkout Code
↓
Build Docker Image
↓
Push Docker Image to ECR
↓
Terraform Init
↓
Terraform Validate
↓
Terraform Plan
```

The workflow automatically selects the correct environment configuration based on the branch being deployed.

---

# Security Considerations

AWS credentials are stored as GitHub Repository Secrets.

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

Environment-specific values are stored as GitHub Variables.

```text
AWS_REGION
AWS_ACCOUNT_ID
ECR_REPOSITORY
```

No sensitive information is stored directly in source control.

---

# Trade-Offs

## Terraform State

Terraform currently uses local state.

This was chosen to keep the exercise focused on infrastructure design and CI/CD implementation.

For a production environment I would introduce:

- S3 Remote Backend
- Bucket Versioning
- DynamoDB State Locking

## Terraform Plan Only

The deployment workflow intentionally generates a Terraform Plan but does not automatically execute Terraform Apply.

This provides:

- Infrastructure review opportunities
- Reduced deployment risk
- Safer change management

---

# Future Improvements

If vpc-tf project were deployed in a production environment, I would implement:

- Remote Terraform State (S3)
- DynamoDB Locking
- GitHub OIDC Authentication
- Private ECS Networking
- Web Application Firewall
- Auto Scaling Policies
- Security Scanning
- Monitoring Dashboards
- Alerting
- Manual Approval Gates

---

# Local Validation

Terraform:

```bash
cd terraform

terraform init

terraform validate
```

Terraform Plan:

```bash
terraform plan \
-var-file=environments/dev.tfvars
```

Docker:

```bash
docker build -t flask_app -f app/Dockerfile app
```
