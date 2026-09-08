# Reference: acli subcommands used by the skill

Verified against acli 1.3.36-stable. Full help is available via `acli <group> <subcommand> --help`.

## Jira

### `jira workitem`
`view | search | edit | create | transition | delete | archive | unarchive | assign | clone | create-bulk | list-watchers`, plus nested groups `attachment`, `comment`, `link`, `watcher`.

- `view [KEY]` — `--fields`, `--json`, `--web`.
- `search` — `--jql`, `--filter`, `--fields`, `--csv|--json`, `--paginate`, `--limit`, `--count`.
- `edit` — `-k/--key`, `--jql`, `--filter`, `-s/--summary`, `-d/--description`, `--description-file`, `-a/--assignee`, `--remove-assignee`, `-l/--labels`, `--remove-labels`, `-t/--type`, `--from-json`, `--generate-json`, `--ignore-errors`, `-y/--yes`, `--json`.
- `comment list` — `--key`, `--order` (default `+created`), `--paginate`, `--limit`, `--json`.
- `transition` — `-k/--key`, `--jql`, `--filter`, `-s/--status`, `--ignore-errors`, `-y/--yes`, `--json`.
- `create` — `-p/--project`, `-t/--type`, `-s/--summary`, `-d/--description`, `--description-file`, `-a/--assignee`, `-l/--label`, `--parent`, `--from-json`, `--generate-json`, `--json`. No `--yes`.
- `create-bulk` — `--from-json`, `--from-csv`, `--generate-json`, `--ignore-errors`, `--yes` (no `-y`).
- `comment create | update | delete | visibility` — the write subcommands take no `--yes`; `visibility` lists the roles/groups a comment can be restricted to.
- `link create | delete | list | type` — `create`: `--in`, `--out`, `--type`, `--from-json`, `--from-csv`, `--generate-json`, `--yes` (no `-y`); `delete`: `--id`, `--from-json`, `--from-csv`, `--yes` (no `-y`); `list`: `--key`, `--json`.
- `list-watchers` — `--key`, `--json`.

### `jira board`
`create | delete | get (deprecated) | list-projects | list-sprints | search | view`.

- `list-sprints` — `--id` (board id), `--state` (`future,active,closed`; comma-separated), `--csv|--json`, `--paginate`, `--limit`.
- `view` — `--id` (required), `--json`. Replaces the deprecated `get`.

### `jira sprint`
`create | delete | update | view | list-workitems`.

- `list-workitems` — `--sprint` (required), `--board` (required), `--jql`, `--fields`, `--csv|--json`, `--paginate`, `--limit`.

### `jira filter`, `jira project`, `jira dashboard`, `jira field`
Out of scope for launch recipes; listed here so users can explore via `--help`.

## Confluence

### `confluence page`
`view` only in 1.3.36.

- `view` — `--id`, `--body-format`, `--include-*` (see `flags.md`), `--status`, `--version`, `--get-draft`, `--json`.

### `confluence blog`
`create | list | view`.

### `confluence space`
`archive | create | list | restore | update | view`.

## Auth

Two distinct surfaces. Global (`acli auth ...`) is OAuth-only in 1.3.36 and has no flags on `login`. Product-scoped (`acli jira auth ...`, `acli confluence auth ...`) carries the `--web`/`--site`/`--email`/`--token` flag matrix. Recipes that hit Jira or Confluence require the matching product-scoped login.

- `acli auth status` — global + per-product auth state. Output lists any products (Jira/Confluence) not yet authenticated.
- `acli auth login <site>.atlassian.net` — global OAuth (positional site, no flags in 1.3.36).
- `acli jira auth login --web` — Jira product OAuth (browser).
- `acli jira auth login --site <site>.atlassian.net --email <you> --token < token.txt` — Jira token flow (stdin).
- `acli confluence auth login --web` — Confluence product OAuth (browser).
- `acli confluence auth login --site <site>.atlassian.net --email <you> --token < token.txt` — Confluence token flow (stdin).
- `acli auth logout` — global logout (OAuth accounts).
- `acli auth switch [--site <s>] [--email <e>]` — switch global account.

## Out of scope

- `rovodev` (Atlassian AI coding agent).
- `admin` commands (org-level operations).
- `guard` (Atlassian Guard CLI).
- `config` (only a `gov-cloud` toggle), `feedback`, `completion`.
