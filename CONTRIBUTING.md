# Contributing & Safety

This repo is public and I (the maintainer) drop production artifacts here from local working directories. That means the publish pipeline has to strip personal data before anything lands. This file documents how that works so contributors and forks can replicate it.

## Threat model

What I'm trying to keep out of the repo:

- API keys (Anthropic, OpenAI, Artificial Analysis, etc.)
- Hardcoded personal home directories (`/Users/<my-username>/`)
- Personal vault paths (private Obsidian dirs, journal locations)
- Tailscale CGNAT IPs (100.64.0.0/10) — homelab leak
- Work email addresses
- Internal team / project / vendor names
- Real customer names from training examples in voice rules

## Defense layers

Four layers, ordered by when they fire:

### 1. `.gitignore` — block at filesystem
Standard ignores for `.env*`, `*.key`, `secrets/`, etc. Won't catch new patterns but kills the obvious ones.

### 2. `scripts/publish-skill.sh` — proactive sanitizer
Before a skill is copied in, this script:
- Replaces `$HOME/` and `/Users/<username>/` with `~/`
- Replaces skill-specific install paths with `./` relative refs
- Replaces Tailscale CGNAT IPs with `<TAILSCALE_IP>` placeholder
- Strips work emails matching company domains
- Runs gitleaks on the sanitized output as a final gate

If any layer fails, the script exits non-zero and nothing copies.

### 3. Pre-commit hook — gitleaks + path scan
Set up with:
```bash
brew install pre-commit gitleaks
pre-commit install
```

The hook config is at [`.pre-commit-config.yaml`](.pre-commit-config.yaml) and runs:
- gitleaks against the staged diff
- A custom grep that fails the commit if any tracked file mentions personal home/vault paths

### 4. GitHub Actions — secret scan on push
[`.github/workflows/secret-scan.yml`](.github/workflows/secret-scan.yml) runs gitleaks + the personal-path grep on every push and PR. Plus GitHub's native secret scanning is automatic for public repos.

## Adding a new skill

If you want to contribute a skill (or fork this and add your own):

1. Drop your local skill at `~/.claude/skills/<name>/`
2. Run `scripts/publish-skill.sh <name>` from the repo root
3. Review the diff in `skills/<name>/`. Look for:
   - Personal references in prose that the regex didn't catch ("Justin's" → "the user's", etc.)
   - First-person framing in SKILL.md ("I do X" → describe behavior generically)
   - Any usernames, project names, or vendor names that snuck through
4. Write `skills/<name>/HOW-TO.md` — reader-facing setup, assumes Claude Code basics but not your homelab
5. Add at least one worked example at `examples/<name>/`
6. Update the README skill table and the badge count
7. Commit. The pre-commit hook will run gitleaks; CI will run it again.

## Manual review checklist

Before you commit anything new, eyeball the diff for:

- [ ] No `/Users/...` paths
- [ ] No `~/vault*` or `~/Documents/<personal-stuff>` references
- [ ] No `100.64-127.x.x` IPs
- [ ] No `<your>@<company>.com` work emails
- [ ] No real names from training examples or voice rules
- [ ] No internal project codenames
- [ ] No hardcoded API keys (gitleaks should catch this, but eyeball anyway)
- [ ] First-person Claude-facing prose in SKILL.md is generic ("the user", not "Justin")

## When the safety layer flags something

If gitleaks or the pre-commit hook flags a file, **fix the root cause** — don't add it to the allowlist unless you're 100% sure it's a false positive. The allowlist is at [`.gitleaks.toml`](.gitleaks.toml) and should grow rarely.

## License

By contributing, you agree your contributions are licensed under the same [MIT License](LICENSE) as the rest of the repo.
