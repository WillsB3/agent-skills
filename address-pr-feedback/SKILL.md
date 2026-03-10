---
name: address-pr-feedback
description: Collect and address PR review feedback from GitHub. Use when the user asks to check PR feedback, review comments, address reviewer suggestions, fix PR review items, or respond to PR comments. Handles feedback from human reviewers and AI reviewers (Greptile, Graphite Agent, etc.).
---

# Address PR Feedback

## Phase 1: Collect Feedback

1. Identify the PR for the current branch:

```bash
gh pr view --json number,title,url
```

2. Fetch all review comments and threads:

```bash
# Top-level PR reviews
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews

# Inline review comments (file-level)
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments

# General issue-style comments
gh api repos/{owner}/{repo}/issues/{pr_number}/comments
```

3. Parse and deduplicate feedback. Identify reviewer type (human vs AI — look for bot accounts or known names like "greptile", "graphite-app").

4. Skip threads already marked as resolved unless the user asks to revisit them.

## Phase 2: Triage with User

Present all feedback as a numbered list. For each item include:
- Reviewer name and type (human / AI)
- File and line reference (if inline)
- Feedback summary
- Suggested code change (if provided)

Ask the user to classify each item into one of:

| Classification | Meaning |
|---|---|
| **Address** | Fix it now |
| **Discuss** | Needs conversation with reviewer — skip |
| **Dismiss** | Not applicable or already handled — skip |

If a structured question tool is available (e.g. `AskQuestion`), prefer using it for the triage step. Otherwise, present the list and ask conversationally.

## Phase 3: Fix Accepted Items

For each item classified as **Address**:

1. Read the relevant file(s) and understand the surrounding context.
2. If the reviewer suggested an approach, evaluate it critically — use it as a starting point but ensure the fix aligns with project conventions. Do not blindly accept suggestions.
3. Implement the fix.
4. Run linting/type checks on affected files.
5. Commit as a **separate git commit** with a clear message.

**Do NOT push after each commit.** Continue to the next item.

## Phase 4: Summary and Push

After all accepted items are addressed:

1. Present a summary of commits made and which feedback item each addresses.
2. Ask the user to confirm they are ready to push.
3. Push via **Graphite CLI** (not `git push`):

```bash
gt submit --stack
```

## Rules

- **One commit per feedback item** — keeps review responses traceable.
- **Never push automatically** — always wait for explicit user confirmation.
- **Always push via `gt submit --stack`** — never `git push` directly.
- **Evaluate suggestions critically** — reviewer suggestions (especially from AI) may miss project conventions or full context.
- **Skip resolved threads** — unless the user explicitly asks to revisit.
