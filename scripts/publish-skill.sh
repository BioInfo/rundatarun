#!/usr/bin/env bash
# publish-skill.sh — sanitize a Claude Code skill from local source into this repo.
#
# Reads from $HOME/.claude/skills/<name>/ (or path passed as 2nd arg), copies into
# skills/<name>/, replacing personal paths/IPs/emails with public-safe equivalents,
# then runs gitleaks as a final gate.
#
# Usage:
#   scripts/publish-skill.sh artificial-analysis
#   scripts/publish-skill.sh skill-name /custom/path/to/skill
#
# After this runs successfully, you still review the diff and write the HOW-TO.md
# manually. Sanitization is mechanical; reader-facing prose is editorial.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ $# -lt 1 ]]; then
    echo "usage: $0 <skill-name> [source-path]" >&2
    exit 1
fi

SKILL_NAME="$1"
SOURCE_DIR="${2:-$HOME/.claude/skills/$SKILL_NAME}"
DEST_DIR="$REPO_ROOT/skills/$SKILL_NAME"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "error: source skill dir not found: $SOURCE_DIR" >&2
    exit 1
fi

echo "==> Sanitizing $SKILL_NAME"
echo "    source: $SOURCE_DIR"
echo "    dest:   $DEST_DIR"

mkdir -p "$DEST_DIR"

# Use Python for sanitization — portable regex, handles edge cases.
python3 "$REPO_ROOT/scripts/sanitize.py" \
    --source "$SOURCE_DIR" \
    --dest "$DEST_DIR" \
    --skill-name "$SKILL_NAME"

# Final gate: run gitleaks against the staged dest
echo "==> Running gitleaks on sanitized output"
if ! gitleaks detect --no-git --source "$DEST_DIR" --config "$REPO_ROOT/.gitleaks.toml" --verbose 2>&1 | tail -20; then
    echo "ERROR: gitleaks found issues in sanitized output. Review and fix before committing." >&2
    exit 2
fi

# Personal-path final scan (belt + suspenders)
echo "==> Personal-path final scan"
if grep -rEn "/Users/bioinfo|/vaults/obsidian" "$DEST_DIR" 2>/dev/null; then
    echo "ERROR: personal path leaked through sanitizer" >&2
    exit 3
fi

echo ""
echo "OK: Sanitized $SKILL_NAME -> $DEST_DIR"
echo "  Next: write skills/$SKILL_NAME/HOW-TO.md (reader-facing setup) and review the diff."
