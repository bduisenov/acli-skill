# Reference: acli flags

acli 1.3.18 has no `--output` switch. Structured output is controlled by per-subcommand boolean flags. Human default is unstructured text; recipes always pass `--json`.

## Common read flags

| Subcommand | `--json` | `--csv` | `--fields` | `--paginate` | `--limit` | `--count` |
|---|---|---|---|---|---|---|
| `jira workitem view` | ✓ | — | ✓ (default: `key,issuetype,summary,status,assignee,description`) | — | — | — |
| `jira workitem search` | ✓ | ✓ | ✓ (default: `issuetype,key,assignee,priority,status,summary`) | ✓ | ✓ | ✓ |
| `jira workitem comment list` | ✓ | — | — | ✓ | ✓ | — |
| `jira sprint list-workitems` | ✓ | ✓ | ✓ (default: `key,issuetype,summary,assignee,priority,status`) | ✓ | ✓ | — |
| `jira board list-sprints` | ✓ | ✓ | — | ✓ | ✓ | — |
| `confluence page view` | ✓ | — | — | — | — | — |
| `confluence blog list` | ✓ | ✓ | — | ✓ | ✓ | — |
| `confluence space list` | ✓ | ✓ | — | ✓ | ✓ | — |

## Write flags (recipes apply via write-gate)

| Subcommand | `-y/--yes` | `--from-json` | `--generate-json` |
|---|---|---|---|
| `jira workitem edit` | ✓ | ✓ | ✓ |
| `jira workitem create` | ✓ | ✓ | ✓ |
| `jira workitem transition` | ✓ | — | — |
| `jira workitem delete` | ✓ | — | — |
| `jira workitem archive` / `unarchive` | ✓ | — | — |
| `jira workitem comment create` / `update` / `delete` | ✓ | — | — |

## `confluence page view` — `--include-*` and `--body-format`

- `--body-format` values: `storage`, `atlas_doc_format`, `view`.
- Booleans to enrich the response (pick what the recipe needs):
  - `--include-collaborators`
  - `--include-direct-children`
  - `--include-favorited-by-current-user-status`
  - `--include-labels`
  - `--include-likes`
  - `--include-operations`
  - `--include-properties`
  - `--include-version`
  - `--include-versions`
  - `--include-webresources`
- `--status` — filter by `current,draft,archived`.
- `--version <int>` — fetch a specific version.
- `--get-draft` — allow returning the draft version.

## JQL-specific

`jira workitem search --jql "…"` — quoting follows shell rules; prefer single quotes in bash. `--paginate` ignores `--limit`.
