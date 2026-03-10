# Agent Skills

Personal AI agent skills that work across Cursor, Claude Code, and Codex.

## Setup

Clone the repo and run the install script to create symlinks in each agent's discovery directory:

```bash
git clone <repo-url> ~/agent-skills
~/agent-skills/install.sh
```

The install script is idempotent — re-run it after adding new skills.

## Adding a new skill

Create a directory with a `SKILL.md` file:

```
my-skill/
└── SKILL.md
```

`SKILL.md` requires YAML frontmatter with `name` and `description`, followed by markdown instructions:

```markdown
---
name: my-skill
description: What this skill does and when to use it.
---

# My Skill

Instructions here.
```

Then run `./install.sh` to symlink it into all agents.

## Skills

| Skill | Description |
|---|---|
| [address-pr-feedback](address-pr-feedback/SKILL.md) | Collect and address PR review feedback from GitHub |
