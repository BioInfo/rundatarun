#!/usr/bin/env bash
# Pre-commit guard: refuse to commit files mentioning personal paths.
set -euo pipefail

PATTERN="/Users/bioinfo|~/vaults/obsidian|justin\.johnson@astrazeneca"

if grep -rEn "$PATTERN" \
    --include="*.md" \
    --include="*.py" \
    --include="*.sh" \
    --include="*.toml" \
    --include="*.yaml" \
    --include="*.yml" \
    --exclude-dir=".git" \
    --exclude="check-no-personal-paths.sh" \
    --exclude="sanitize.py" \
    --exclude="publish-skill.sh" \
    --exclude=".gitleaks.toml" \
    --exclude=".pre-commit-config.yaml" \
    --exclude="secret-scan.yml" \
    --exclude="CONTRIBUTING.md" \
    --exclude="README.md" \
    .; then
    echo ""
    echo "ERROR: personal path or work email found in files above. Sanitize before committing."
    exit 1
fi
