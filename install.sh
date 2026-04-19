#!/usr/bin/env bash
# Install script for a user-owned universal Claude Code config repo.
# Copies CLAUDE.md, docs/*.md, commands/*.md, and agents/*.md into ~/.claude/
# after cloning a shallow copy of the configured GitHub repository.
#
# Compatible with bash 3.2+ (macOS default).

set -euo pipefail
IFS=$'\n\t'

OWNER="${CLAUDE_CONFIG_OWNER:-Wilky00}"
REPO="${CLAUDE_CONFIG_REPO:-universal-claude-code-config}"
BRANCH="${CLAUDE_CONFIG_BRANCH:-main}"
REPO_URL="${CLAUDE_CONFIG_GIT_URL:-https://github.com/${OWNER}/${REPO}.git}"
RAW_BASE="${CLAUDE_CONFIG_RAW_BASE:-https://raw.githubusercontent.com/${OWNER}/${REPO}/${BRANCH}}"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
VERSION_FILE="$CLAUDE_DIR/.claude-config-version"
MANIFEST_FILE="$CLAUDE_DIR/.claude-config-manifest"
STAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_DIR="$CLAUDE_DIR/backups/claude-config-${STAMP}"
TMP_DIR="$(mktemp -d)"
REPO_DIR="$TMP_DIR/repo"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  echo -e "${RED}Error:${NC} $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

backup_if_exists() {
  local rel="$1"
  local dest="$CLAUDE_DIR/$rel"
  if [[ -f "$dest" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp "$dest" "$BACKUP_DIR/$rel"
    echo -e "${YELLOW}Backed up${NC} $rel"
  fi
}

install_file() {
  local rel="$1"
  local src="$REPO_DIR/$rel"
  local dest="$CLAUDE_DIR/$rel"

  [[ -f "$src" ]] || fail "Expected file missing in repository: $rel"
  mkdir -p "$(dirname "$dest")"
  backup_if_exists "$rel"
  install -m 0644 "$src" "$dest"
  echo -e "${GREEN}✓${NC} $rel"
}

require_cmd git
require_cmd mktemp
require_cmd install

mkdir -p "$CLAUDE_DIR" "$CLAUDE_DIR/docs" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/backups"

echo ""
echo "Installing Claude config from ${OWNER}/${REPO} (${BRANCH})..."
echo -e "Repository: ${CYAN}${REPO_URL}${NC}"
echo ""

git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR" \
  || fail "Could not clone ${REPO_URL}. If the repo is private, set CLAUDE_CONFIG_GIT_URL to an SSH URL."

[[ -f "$REPO_DIR/CLAUDE.md" ]]   || fail "Repository does not contain CLAUDE.md"
[[ -d "$REPO_DIR/docs" ]]        || fail "Repository does not contain a docs/ directory"
[[ -d "$REPO_DIR/commands" ]]    || fail "Repository does not contain a commands/ directory"

# Build file lists without mapfile (bash 3.2 compatible)
DOC_FILES=()
while IFS= read -r line; do
  [[ -n "$line" ]] && DOC_FILES+=("$line")
done < <(cd "$REPO_DIR" && find docs -maxdepth 1 -type f -name '*.md' | sort)

COMMAND_FILES=()
while IFS= read -r line; do
  [[ -n "$line" ]] && COMMAND_FILES+=("$line")
done < <(cd "$REPO_DIR" && find commands -maxdepth 1 -type f -name '*.md' | sort)

AGENT_FILES=()
if [[ -d "$REPO_DIR/agents" ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && AGENT_FILES+=("$line")
  done < <(cd "$REPO_DIR" && find agents -maxdepth 1 -type f -name '*.md' | sort)
fi

install_file "CLAUDE.md"

for rel in "${DOC_FILES[@]}"; do
  install_file "$rel"
done

for rel in "${COMMAND_FILES[@]}"; do
  install_file "$rel"
done

for rel in "${AGENT_FILES[@]}"; do
  install_file "$rel"
done

{
  echo "CLAUDE.md"
  printf '%s\n' "${DOC_FILES[@]}"
  printf '%s\n' "${COMMAND_FILES[@]}"
  [[ ${#AGENT_FILES[@]} -gt 0 ]] && printf '%s\n' "${AGENT_FILES[@]}"
} > "$MANIFEST_FILE"

REVISION="${BRANCH}@$(git -C "$REPO_DIR" rev-parse --short HEAD)"
printf '%s\n' "$REVISION" > "$VERSION_FILE"

echo ""
echo -e "${GREEN}Done!${NC} Installed revision ${CYAN}${REVISION}${NC}"
if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(find "$BACKUP_DIR" -type f -print -quit 2>/dev/null)" ]]; then
  echo -e "Backup saved to ${CYAN}${BACKUP_DIR}${NC}"
fi

echo ""
echo "Next steps:"
echo "  1. Open ~/.claude/CLAUDE.md"
echo "  2. Verify the Technology Standards references match the files in ~/.claude/docs/"
echo "  3. Start Claude Code and validate the global rules in a test repo"
echo ""
echo "Upgrade later with: curl -fsSL ${RAW_BASE}/upgrade.sh | bash"
echo "Uninstall with:    curl -fsSL ${RAW_BASE}/uninstall.sh | bash"
echo ""
