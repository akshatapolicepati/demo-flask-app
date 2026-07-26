Deployment Update – Flask Expense Tracker

## Summary

A new release of the Flask Expense Tracker platform has been promoted through the deployment pipeline.

The release includes application updates and infrastructure validation using Terraform and GitHub Actions.

---

## Environment

Environment selection is branch-based:

```text
development → DEV

staging → STAGING

main → PROD
```

Current target environment is determined automatically by the deployment pipeline.

---

## What's Included

- Updated application container image

- Docker image published to Amazon ECR

- Terraform validation completed

- Terraform plan generated for review

- Environment-specific configuration selected automatically

---

## Impact

- No expected user impact
- No downtime expected
- No infrastructure changes automatically applied
- Infrastructure changes remain reviewable through Terraform Plan output

---

## Deployment Window

Deployment pipeline is triggered automatically after merge.

Expected execution time:

```text
3–5 minutes
```

---

## References

Repository

```text
https://github.com/akshatapolicepati/FLASK_APP
```

Documentation

```text
README.md
```

Operational Runbook

```text
RUNBOOK.md
```

Pipeline Runs

```text
GitHub Actions
```

---

## Risks

- Terraform Apply is intentionally disabled.
- Infrastructure changes require review before implementation.
- Changes are limited to validation and planning activities.

---

## Support

Owner: Akshata Police Pati

For deployment-related issues, please contact the platform owner and include the GitHub Actions run URL in the request.
