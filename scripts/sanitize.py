#!/usr/bin/env python3
"""Sanitize a Claude Code skill or rules file for public publishing.

Replaces personal paths, Tailscale IPs, work emails, and home references
with public-safe equivalents. Skips binary files (copies verbatim).
"""

import argparse
import re
import shutil
from pathlib import Path

TEXT_EXTENSIONS = {".md", ".py", ".sh", ".txt", ".yaml", ".yml", ".toml", ".json", ".cfg", ".ini"}

# Order matters — most specific first.
SUBSTITUTIONS = [
    # Tailscale CGNAT range (100.64.0.0/10)
    (re.compile(r"\b100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\.\d{1,3}\.\d{1,3}\b"),
     "<TAILSCALE_IP>"),
    # AstraZeneca work email
    (re.compile(r"[a-zA-Z0-9._%+-]+@astrazeneca\.com"),
     "<work-email>"),
    # Personal home dir variants
    (re.compile(r"/Users/bioinfo/"), "~/"),
    (re.compile(r"/Users/bioinfo$"), "~"),
    # Personal vault path
    (re.compile(r"~?/?vaults/obsidian/"), "~/vault/"),
    (re.compile(r"~?/?vaults/obsidian"), "~/vault"),
]

def sanitize_text(text: str, skill_name: str) -> str:
    # Skill-specific path collapses
    text = text.replace(f"~/.claude/skills/{skill_name}/", "./")
    text = text.replace(f"~/apps/claude-code/skills/{skill_name}/", "./")
    text = text.replace(f"~/.claude/skills/{skill_name}", ".")
    text = text.replace(f"~/apps/claude-code/skills/{skill_name}", ".")

    for pattern, replacement in SUBSTITUTIONS:
        text = pattern.sub(replacement, text)
    return text

def sanitize_file(src: Path, dest: Path, skill_name: str) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if src.suffix.lower() in TEXT_EXTENSIONS:
        try:
            text = src.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            shutil.copy2(src, dest)
            return
        dest.write_text(sanitize_text(text, skill_name), encoding="utf-8")
        # Preserve executable bit
        if src.stat().st_mode & 0o111:
            dest.chmod(dest.stat().st_mode | 0o755)
    else:
        shutil.copy2(src, dest)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True, type=Path)
    ap.add_argument("--dest", required=True, type=Path)
    ap.add_argument("--skill-name", required=True)
    args = ap.parse_args()

    if not args.source.is_dir() and not args.source.is_file():
        raise SystemExit(f"source not found: {args.source}")

    if args.source.is_file():
        sanitize_file(args.source, args.dest, args.skill_name)
        print(f"  sanitized: {args.source.name}")
        return

    count = 0
    for src in args.source.rglob("*"):
        if not src.is_file():
            continue
        # Skip caches, hidden bookkeeping
        if any(part.startswith(".") and part not in (".",) for part in src.relative_to(args.source).parts):
            continue
        rel = src.relative_to(args.source)
        sanitize_file(src, args.dest / rel, args.skill_name)
        count += 1
    print(f"  sanitized {count} file(s)")

if __name__ == "__main__":
    main()
