# Reference: acli flags

acli 1.3.39 has no `--output` switch. Structured output is controlled by per-subcommand boolean flags. Human default is unstructured text; recipes always pass `--json`.

## Common read flags

| Subcommand | `--json` | `--csv` | `--fields` | `--paginate` | `--limit` | `--count` |
|---|---|---|---|---|---|---|
| `jira workitem view` | ✓ | — | ✓ (default: `key,issuetype,summary,status,assignee,description`) | — | — | — |
| `jira workitem search` | ✓ | ✓ | ✓ (default: `issuetype,key,assignee,priority,status,summary`) | ✓ | ✓ | ✓ |
| `jira workitem comment list` | ✓ | — | — | ✓ | ✓ | — |
| `jira sprint list-workitems` | ✓ | ✓ | ✓ (default: `key,issuetype,summary,assignee,priority,status`) | ✓ | ✓ | — |
| `jira board list-sprints` | ✓ | ✓ | — | ✓ | ✓ | — |
| `confluence page view` | ✓ | — | — | — | — | — |
| `confluence blog list` | ✓ | ✓ | — | — (cursor-based: `--cursor`) | ✓ | — |
| `confluence space list` | ✓ | — | — | — | ✓ | — |

`jira workitem view --fields` also accepts `*all`, `*navigable`, and a minus prefix to exclude a field (e.g. `*navigable,-comment`).

## Write flags (recipes apply via write-gate)

`--yes` exists only on the subcommands where acli asks for confirmation, and the `-y` shorthand only on a subset of those. Write-gate appends the long form `--yes` where the matrix shows it and appends nothing where it does not — on the `—` rows acli rejects the flag as `unknown flag`.

| Subcommand | `--yes` | `-y` | `--from-json` | `--generate-json` |
|---|---|---|---|---|
| `jira workitem edit` | ✓ | ✓ | ✓ | ✓ |
| `jira workitem transition` | ✓ | ✓ | — | — |
| `jira workitem assign` | ✓ | ✓ | — | — |
| `jira workitem clone` | ✓ | ✓ | — | — |
| `jira workitem delete` | ✓ | ✓ | — | — |
| `jira workitem archive` / `unarchive` | ✓ | ✓ | — | — |
| `jira workitem create-bulk` | ✓ | — | ✓ | ✓ |
| `jira workitem link create` | ✓ | — | ✓ | ✓ |
| `jira workitem link delete` | ✓ | — | ✓ | — |
| `jira workitem create` | — | — | ✓ | ✓ |
| `jira workitem comment create` / `update` / `delete` | — | — | — | — |
| `confluence blog create` | — | — | ✓ | ✓ |
| `confluence space create` / `update` / `archive` / `restore` | — | — | — | — |

Subcommands without `--yes` have no confirmation prompt. They still prompt for content missing from the command line — `workitem create` for summary/description (`-e/--editor` opens an editor for them), `comment create` for the body — so write-gate requires every content field to be passed as a flag or a file.

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

`jira workitem search --jql "…"` — quoting follows shell rules; prefer single quotes in bash. Help does not say how `--paginate` and `--limit` interact on `search`; pass one or the other. (`comment list` help does say `--paginate` ignores `--limit`.)
