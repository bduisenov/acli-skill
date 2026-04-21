# acli-skill

Claude Code plugin that wraps the [Atlassian CLI](https://developer.atlassian.com/cloud/acli/guides/how-to-get-started/) (`acli`) with workflow recipes for Jira and Confluence.

## What it does

- **Reads Jira work items** — fetch a ticket with its description, linked issues, and comments; break down an epic into its children; snapshot an active sprint.
- **Reads Confluence pages** — fetch a page by ID or URL, including metadata (version, labels, space).
- **Gates writes** — every Jira / Confluence write (`edit`, `create`, `transition`, `delete`, etc.) requires a skill-layer confirmation and injects `-y` to avoid hanging on acli's interactive prompt.
- **Never logs in on your behalf** — the skill runs `acli auth status` but never `acli auth login`.

## Requirements

- [Atlassian CLI (`acli`)](https://developer.atlassian.com/cloud/acli/guides/how-to-get-started/) ≥ 1.3.18.
- Claude Code with plugin support.
- An authenticated session (`acli auth login --web`) before use.

## Install

```
/plugin marketplace add bduisenov/acli-skill
/plugin install acli@acli-skill
```

## Usage

The skill auto-triggers on a Jira issue key (e.g. `RCA-123`), the literal word `acli`, `jira`, or `confluence`, or qualified phrases like `confluence page`, `wiki page`, `jira ticket`, `epic breakdown`, `sprint snapshot`. Bare words (`page`, `ticket`, `sprint`) do NOT trigger — see [`skills/acli/SKILL.md`](skills/acli/SKILL.md) for the authoritative trigger list. Explicit invoke: `/acli:acli`.

### Recipes

| Recipe | When it fires |
|---|---|
| [RCA ticket fetch](skills/acli/recipes/rca-fetch.md) | You mention an RCA / PROJ key and want context |
| [Epic breakdown](skills/acli/recipes/epic-breakdown.md) | You ask to break down or list children of an epic |
| [Sprint state](skills/acli/recipes/sprint-state.md) | You ask for the current sprint or standup snapshot |
| [Confluence page fetch](skills/acli/recipes/confluence-page-fetch.md) | You give a page ID or a Confluence URL |

### Protocols

- [`auth-preflight.md`](skills/acli/protocols/auth-preflight.md) — version gate, auth status, multi-site handling.
- [`write-gate.md`](skills/acli/protocols/write-gate.md) — per-call confirmation for all writes.

## Known limitations (acli 1.3.18)

- **No Confluence page search.** `acli confluence page` only supports `view` by ID.
- **Jira Cloud only.** No Data Center / Server support.
- **Multi-site tenants.** If `acli auth status` lists more than one active site, the skill asks you to pick; it does not auto-select.
- **Epic children.** The recipe uses `parent = <EPIC>` (modern schema). On legacy schemas the fallback is `"Epic Link" = <EPIC>` — explicit, not silent.

## Development

Run the flag-surface smoke test to catch upstream drift:

```bash
./scripts/smoke.sh
```

## License

MIT — see [`LICENSE`](LICENSE).
