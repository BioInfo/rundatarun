<p align="center">
  <img src=".readme-assets/banner.png" alt="rundatarun" width="100%">
</p>

<p align="center">
  <a href="https://github.com/BioInfo/rundatarun/stargazers"><img src="https://img.shields.io/github/stars/BioInfo/rundatarun?style=flat&color=yellow" alt="Stars"></a>
  <a href="https://github.com/BioInfo/rundatarun/network/members"><img src="https://img.shields.io/github/forks/BioInfo/rundatarun?style=flat&color=blue" alt="Forks"></a>
  <a href="https://github.com/BioInfo/rundatarun/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/Claude_Code-compatible-blueviolet" alt="Claude Code"></a>
  <a href="#skills"><img src="https://img.shields.io/badge/skills-2-orange" alt="Skills"></a>
  <a href="#rules"><img src="https://img.shields.io/badge/rules-2-orange" alt="Rules"></a>
  <a href="#examples"><img src="https://img.shields.io/badge/examples-5-orange" alt="Examples"></a>
  <a href="https://rundatarun.io"><img src="https://img.shields.io/badge/substack-rundatarun.io-09090b?style=flat" alt="Substack"></a>
</p>

<p align="center">
  <a href="#what-this-is">What this is</a> &bull;
  <a href="#quick-start">Quick Start</a> &bull;
  <a href="#skills">Skills</a> &bull;
  <a href="#rules">Rules</a> &bull;
  <a href="#examples">Examples</a> &bull;
  <a href="#companion-repos">Companion Repos</a>
</p>

---

## What this is

Skills, rules, and worked examples I actually use in [Claude Code](https://claude.ai/code). Production artifacts, not tutorials. Each skill ships with a how-to and at least one worked example showing what it does on a real question.

Companion to [Run Data Run](https://rundatarun.io) — when something I write about gets baked into a skill, this is where the skill lives.

## Quick Start

```bash
git clone https://github.com/BioInfo/rundatarun.git
cd rundatarun

# Skills (auto-discovered by Claude Code on next session)
cp -r skills/artificial-analysis ~/.claude/skills/

# Rules (auto-loaded into the system prompt)
cp rules/*.md ~/.claude/rules/
```

That's it. Skills surface when their triggers fire; rules apply globally.

## Skills

Each skill lives at `skills/<name>/` with a `SKILL.md` (the Claude-facing file) and a `HOW-TO.md` (the human-facing setup walkthrough).

| Skill | What it does | How-to |
|---|---|---|
| [`artificial-analysis`](skills/artificial-analysis/) | Live model comparisons from [artificialanalysis.ai](https://artificialanalysis.ai). Triggers on "compare X and Y", "fastest model", "cheapest", coding/math/intelligence questions. Returns 3-5 ranked rows with the relevant tradeoff named. | [HOW-TO](skills/artificial-analysis/HOW-TO.md) |
| [`dossier`](skills/dossier/) | Decodes an AI company past the marketing site. Always comparative: surfaces 3 contextual alternatives + 1 contrarian "build internal" option, lands a take-the-meeting verdict, and writes 2-3 prep questions sharp enough to expose the gap in 90 seconds. Triggers on "have you seen X", "decode X", "should I take a meeting with X". | [HOW-TO](skills/dossier/HOW-TO.md) |

More skills are queued — adding them as I sanitize them.

## Rules

Drop these in `~/.claude/rules/` and Claude Code auto-loads them into the system prompt at session start.

| Rule | What it does |
|---|---|
| [`decision-making.md`](rules/decision-making.md) | Triggers a Kahneman/Klein **premortem** before non-trivial decisions. "Imagine the decision failed in 6 months — write the post-mortem from that future." |
| [`estimation.md`](rules/estimation.md) | Forces time estimates at Claude Code speed (compute-bound), not hand-coding speed. Stops you from padding for "setup" and "debugging" that don't exist when Claude is writing the code. |

See [`rules/README.md`](rules/README.md) for install notes.

## Examples

Worked examples live at `examples/<topic>/`. Real questions, real outputs, no canned demos.

| Example | Skill / Rule | Question |
|---|---|---|
| [`best-under-50b.md`](examples/artificial-analysis/best-under-50b.md) | artificial-analysis | "Best and fastest open-source model under 50B?" |
| [`top-coding-models.md`](examples/artificial-analysis/top-coding-models.md) | artificial-analysis | "Which model has the best coding score right now?" |
| [`speed-vs-intel-tradeoff.md`](examples/artificial-analysis/speed-vs-intel-tradeoff.md) | artificial-analysis | "Find the speed-vs-intelligence Pareto frontier." |
| [`premortem-walkthrough.md`](examples/decision-making/premortem-walkthrough.md) | decision-making | A premortem on a hypothetical "let's migrate to Postgres" decision. |
| [`fractal-analytics-walkthrough.md`](examples/dossier/fractal-analytics-walkthrough.md) | dossier | Worked decode of Fractal Analytics for an AI product leader at a clinical data vendor. Shows the 3+1 alternatives, opener question, and verdict. |

## Companion Repos

This repo is one of three. Together they cover three layers of how I use Claude:

| Repo | Layer | What it covers |
|---|---|---|
| [**slopless**](https://github.com/BioInfo/slopless) | How Claude **writes** | Anti-AI-slop voice rules, banned-word lists, hooks, statusline. The prose-quality layer. |
| [**rundatarun**](https://github.com/BioInfo/rundatarun) | What Claude **does** | Skills, rules, and worked examples for general technical work. (← you are here) |
| [**builder-leader-book**](https://github.com/BioInfo/builder-leader-book) | What Claude does, **applied** | The production pipeline behind my book *Builder-Leader* — drafting, fact-checking, voice polish, multi-stage critique skills. |

Pick the layer you want. They compose.

## Safety

This repo is publicly visible, so the publish pipeline strips personal data before anything lands here:

- `gitleaks` pre-commit hook + GitHub Actions secret scan on every push
- Custom denylist for personal home paths, Tailscale IPs, work emails
- A [`scripts/publish-skill.sh`](scripts/publish-skill.sh) sanitizer that runs before any skill is copied in

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full safety model.

## License

[MIT](LICENSE). Use, fork, modify. Attribution appreciated, not required.

---

<p align="center">
  <a href="https://rundatarun.io">Run Data Run</a> &bull;
  <a href="https://x.com/bioinfo">@bioinfo</a> &bull;
  <a href="https://github.com/BioInfo">github/BioInfo</a>
</p>
