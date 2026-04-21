---
name: acli
description: Use when the user mentions Jira issue keys (RCA-*, PROJ-*, etc), Confluence pages, or the keywords jira/confluence/ticket/epic/sprint/wiki/page; also when `acli` is mentioned explicitly. Provides workflow recipes for reading Jira work items and Confluence pages via the Atlassian CLI. Writes are gated — auto-triggers fire for reads only; writes require an explicit verb (edit, create, update, transition, delete, assign, archive, clone, link).
---

# acli — Atlassian CLI workflows

Wraps `acli` 1.3.18+ with four recipes plus two protocols.

## Workflow

1. **Auth preflight first.** Follow `protocols/auth-preflight.md` — version gate, `acli auth status`, surface stderr verbatim on failure. The skill never runs `acli auth login`.
2. **For reads**, jump straight to the relevant recipe below.
3. **For writes**, follow `protocols/write-gate.md` — confirm at the skill layer, inject `-y`, fall back to copy-paste on destructive subcommands.

## Recipes

| Recipe | Trigger | File |
|---|---|---|
| RCA ticket fetch | user mentions an RCA key or asks for RCA context | `recipes/rca-fetch.md` |
| Epic breakdown | user asks to break down / list children of an epic | `recipes/epic-breakdown.md` |
| Sprint state | user asks for current sprint, standup snapshot | `recipes/sprint-state.md` |
| Confluence page fetch | user gives a page ID or a Confluence URL | `recipes/confluence-page-fetch.md` |

## Reference

- `reference/commands.md` — acli subcommand reference for the subset the skill uses.
- `reference/flags.md` — per-subcommand flag matrix.
- `reference/jql-snippets.md` — canonical JQL library.

## Protocols

- `protocols/auth-preflight.md` — first call of every session.
- `protocols/write-gate.md` — every write call, both products.

## Rules

- Auto-triggers fire for reads only. Writes require an explicit English verb in the user's request.
- Writes always pass through `protocols/write-gate.md`. No exceptions.
- Skill never invokes `acli auth login`.
