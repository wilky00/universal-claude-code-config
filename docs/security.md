# Security Standards

## Secrets
- Never commit secrets, tokens, API keys, certificates, or password-bearing config files.
- Use `.env` locally and secret injection in deployed environments.
- Commit `.env.example` only.

## Validation
- Validate all external inputs at system boundaries.
- Never interpolate raw user input into shell commands, SQL, or file paths.
- Prefer allowlists over deny lists for command, path, and host validation.

## Logging
- Never log secrets, full tokens, passwords, or PII.
- Redact sensitive fields in debug logs.
- Keep logs useful for diagnosis without exposing private data.

## Network Safety
- Prefer private networks, VPN, or reverse proxy auth over direct public exposure.
- Flag any config that publishes admin or management ports broadly.

## File Safety
- Be careful with `rm`, `mv`, recursive operations, and permission changes.
- Show the exact impact before destructive commands when the blast radius is unclear.

## Review
- Before proposing deployment changes, check for:
  - secret leakage risk
  - overexposed ports
  - weak auth assumptions
  - excessive container privileges
  - broad filesystem mounts