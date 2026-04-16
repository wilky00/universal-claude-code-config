# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| latest (main) | ✓ |

## Reporting a Vulnerability

**Please do not report security vulnerabilities via public GitHub issues.**

If you find a security issue — such as malicious content in `CLAUDE.md`, a compromised `install.sh`, or anything that could cause harm to someone installing this config — please report it privately:

**Email:** open a [GitHub Security Advisory](https://github.com/wilky00/universal-claude-code-config/security/advisories/new)

Include:
- A description of the issue
- Steps to reproduce or proof of concept
- The potential impact

You can expect an initial response within **48 hours** and a resolution or mitigation within **7 days** for confirmed issues.

## Scope

Security issues relevant to this repo include:

- Malicious shell commands in `install.sh`
- Rules in `CLAUDE.md` or `docs/` designed to exfiltrate data or cause harm
- Supply chain issues (compromised dependencies or download URLs)
- Anything that could damage a user's system or Claude Code configuration on install

Out of scope: general Claude Code bugs, Anthropic API issues, or questions about Claude's behavior. Those should go to [Anthropic's support](https://support.anthropic.com).
