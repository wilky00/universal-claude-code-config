# AWS Standards

## Compute
- Run applications in Docker containers on EC2
- Use `docker compose` for multi-container setups
- Never install app dependencies directly on the host OS

## IAM
- Follow least-privilege — grant only permissions actually needed
- No wildcard `*` actions in IAM policies unless unavoidable
- Use IAM roles for EC2 instances — never put credentials on the instance
- No long-lived IAM access keys for services running on AWS

## Secrets & Configuration
- Inject all secrets via environment variables — never hardcode in code or config files
- Use `.env` files locally; use EC2 instance environment or AWS Secrets Manager in production
- Never commit credentials, even to private repos

## Regions
- Never hardcode AWS region strings in code
- Read region from environment variable (`AWS_DEFAULT_REGION`) or instance metadata

## General
- Tag all AWS resources with at minimum: `project`, `environment`
- Prefer managed services over self-managed where practical
