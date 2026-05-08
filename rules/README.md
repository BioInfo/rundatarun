# Rules

Auto-loaded behavior rules for Claude Code. Drop these into `~/.claude/rules/` and they get pulled into the system prompt at session start.

## How rules work

Claude Code auto-loads any `.md` file in `~/.claude/rules/` (along with `~/.claude/CLAUDE.md` or `AGENTS.md`). Rules apply globally across all projects.

Each file in this dir is a single, named behavior pattern. Pick the ones that match how you work — none of these are mandatory.

## Files

| Rule | What it does |
|---|---|
| [`decision-making.md`](decision-making.md) | Triggers a Kahneman/Klein **premortem** before non-trivial decisions. Imagine the decision failed in 6 months — write the post-mortem from that future. |
| [`estimation.md`](estimation.md) | Forces time estimates at Claude Code speed (compute-bound), not hand-coding speed. Stops you from padding for "setup" and "debugging" that don't exist when Claude is writing the code. |

## Install

```bash
# From the rundatarun repo root:
cp rules/*.md ~/.claude/rules/

# Or pick specific ones:
cp rules/decision-making.md ~/.claude/rules/
```

## Companion repo

For writing-voice rules (anti-AI-slop banned-word lists, voice ladders, hooks), see [slopless](https://github.com/BioInfo/slopless) — it's the prose-quality companion to this repo's behavior rules.
