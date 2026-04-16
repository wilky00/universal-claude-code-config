#!/usr/bin/env bash
# Upgrade script for a user-owned universal Claude Code config repo.
# Reuses the install process after showing the current and remote revision.

set -Eeuo pipefail
IFS=$'\n\t'

OWNER="${CLAUDE_CONFIG_OWNER:-Wilky00}"
REPO="${CLAUDE_CONFIG_REPO:-universal-claude-code-config}"
BRANCH="${CLAUDE_CONFIG_BRANCH:-main}"
REPO_URL="${CLAUDE_CONFIG_GIT_URL:-https://github.com/${OWNER}/${REPO}.git}"
RAW_BASE="${CLAUDE_CONFIG_RAW_BASE:-https://raw.githubusercontent.com/${OWNER}/${REPO}/${BRANCH}}"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
VERSION_FILE="$CLAUDE_DIR/.claude-config-version"
TMP_DIR="$(mktemp -d)"
REPO_DIR="$TMP_DIR/repo"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  echo -e "${RED}Error:${NC} $*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || fail "Required command not found: git"
command -v curl >/dev/null 2>&1 || fail "Required command not found: curl"

INSTALLED="unknown"
[[ -f "$VERSION_FILE" ]] && INSTALLED="$(cat "$VERSION_FILE")"

git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR" \
  || fail "Could not clone ${REPO_URL}. If the repo is private, set CLAUDE_CONFIG_GIT_URL to an SSH URL."

LATEST="${BRANCH}@$(git -C "$REPO_DIR" rev-parse --short HEAD)"

echo ""
echo -e "Installed: ${CYAN}${INSTALLED}${NC}"
echo -e "Latest:    ${CYAN}${LATEST}${NC}"
echo ""

if [[ "$INSTALLED" == "$LATEST" ]]; then
  echo -e "${GREEN}Already up to date.${NC}"
  echo ""
  exit 0
fi

read -r -p "Upgrade now? [y/N] " response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  echo ""
  exit 0
fi

bash <(curl -fsSL "${RAW_BASE}/install.sh")
