# Docker Standards

## General
- Always use `docker compose`, never `docker-compose`.
- Prefer the filename `docker-compose.yml`.
- Prefer one app per directory with clear ownership of volumes, env files, and networks.
- Never use the deprecated "Version:" tag in compose files. 
## Compose Structure
- Keep services, volumes, and networks explicit.
- Add `healthcheck` where the service supports it.
- Use restart policies intentionally, usually `unless-stopped` for homelab services.
- Prefer named volumes for app data unless a bind mount is required.

## Environment and Secrets
- Keep secrets in `.env` or external secret stores.
- Commit `.env.example` only, never real secrets.
- Do not hardcode tokens, passwords, or API keys in compose files.

## Ports and Networking
- Expose only the ports that must be reachable.
- Prefer internal Docker networking over host exposure when reverse proxying.
- Document every exposed port with a comment or clear service naming.

## Validation
- Run `docker compose config` after changes.
- Prefer targeted changes to existing compose files rather than full rewrites.
- Preserve existing container names, networks, and volume names unless a migration is intentional.

## User Preferences
- Keep compose output copy-paste ready.