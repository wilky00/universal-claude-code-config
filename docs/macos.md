# macOS Standards

## Environment
- Assume Apple Silicon unless the repo or host clearly indicates Intel.
- Prefer Homebrew-managed binaries under `/opt/homebrew/bin`.
- Use `python3`, not `python`.
- Use `zsh` as the default interactive shell unless a project explicitly requires `bash`.

## File and Process Management
- Prefer `~/Developer/<project>` or the existing repo location. Do not invent new top-level directories.
- Never write outside the project directory unless asked.
- For long-running local services, prefer `launchctl` only when the user explicitly wants a macOS-native service.
- Do not suggest Linux-only service managers like `systemctl` for local Mac tasks.

## Editing and CLI Conventions
- Assume the user prefers `vi` for terminal editing guidance.
- Prefer native tools first: `pbcopy`, `pbpaste`, `open`, `lsof`, `ps`, `log`.
- Be careful with BSD vs GNU command differences on macOS.
- Do not assume `sed -i` GNU behavior. Use macOS-safe syntax or provide both forms.

## Networking
- Prefer `lsof -i`, `netstat`, and `curl` for local troubleshooting.
- When binding local services, prefer `127.0.0.1` unless remote access is explicitly required.

## Safety
- Never disable SIP, Gatekeeper, or macOS security features unless explicitly asked and the risks are explained.
- Never recommend broad `sudo` usage when a user-level fix is enough.