#!/usr/bin/env bash
# Uninstall script for a user-owned universal Claude Code config repo.
# Removes files tracked in ~/.claude/.claude-config-manifest and can restore backups.

set -Eeuo pipefail
IFS=$'\n\t'

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
MANIFEST_FILE="$CLAUDE_DIR/.claude-config-manifest"
VERSION_FILE="$CLAUDE_DIR/.claude-config-version"
BACKUP_ROOT="$CLAUDE_DIR/backups"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

fail() {
  echo -e "${RED}Error:${NC} $*" >&2
  exit 1
}

[[ -f "$MANIFEST_FILE" ]] || fail "Manifest not found at $MANIFEST_FILE. Refusing to guess which files to remove."

echo ""
echo "Uninstalling Claude config files listed in ${MANIFEST_FILE}..."
echo ""

while IFS= read -r rel; do
  [[ -n "$rel" ]] || continue
  target="$CLAUDE_DIR/$rel"
  if [[ -f "$target" ]]; then
    rm -f "$target"
    echo -e "${GREEN}✓${NC} Removed $rel"
  fi
done < "$MANIFEST_FILE"

rm -f "$MANIFEST_FILE" "$VERSION_FILE"

echo ""
if [[ -d "$BACKUP_ROOT" ]]; then
  latest_backup="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"
  if [[ -n "$latest_backup" ]]; then
    echo -e "Latest backup: ${CYAN}${latest_backup}${NC}"
    read -r -p "Restore files from that backup now? [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      (cd "$latest_backup" && find . -type f -print) | while IFS= read -r rel; do
        rel="${rel#./}"
        mkdir -p "$CLAUDE_DIR/$(dirname "$rel")"
        cp "$latest_backup/$rel" "$CLAUDE_DIR/$rel"
        echo -e "${YELLOW}Restored${NC} $rel"
      done
    fi
  fi
fi

echo ""
echo -e "${GREEN}Done.${NC}"
echo ""
