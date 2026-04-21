# Reference: acli subcommands used by the skill

Verified against acli 1.3.18-stable. Full help is available via `acli <group> <subcommand> --help`.

## Jira

### `jira workitem`
`view | search | edit | create | transition | delete | archive | unarchive | assign | clone | link | create-bulk`, plus nested `attachment`, `comment`, `watcher`.

- `view [KEY]` — `--fields`, `--json`, `--web`.
- `search` — `--jql`, `--filter`, `--fields`, `--csv|--json`, `--paginate`, `--limit`, `--count`.
- `edit` — `-k/--key`, `--jql`, `--filter`, `-s/--summary`, `-d/--description`, `--description-file`, `-a/--assignee`, `--remove-assignee`, `-l/--labels`, `--remove-labels`, `-t/--type`, `--from-json`, `--generate-json`, `--ignore-errors`, `-y/--yes`, `--json`.
- `comment list` — `--key`, `--order` (default `+created`), `--paginate`, `--limit`, `--json`.
- `transition` — `-k/--key`, `--status`, `-y/--yes`, `--json`.

### `jira board`
`create | delete | get | list-projects | list-sprints | search`.

- `list-sprints` — `--id` (board id), `--state` (`future,active,closed`; comma-separated), `--csv|--json`, `--paginate`, `--limit`.

### `jira sprint`
`create | delete | update | view | list-workitems`.

- `list-workitems` — `--sprint` (required), `--board` (required), `--jql`, `--fields`, `--csv|--json`, `--paginate`, `--limit`.

### `jira filter`, `jira project`, `jira dashboard`, `jira field`
Out of scope for launch recipes; listed here so users can explore via `--help`.

## Confluence

### `confluence page`
`view` only in 1.3.18.

- `view` — `--id`, `--body-format`, `--include-*` (see `flags.md`), `--status`, `--version`, `--get-draft`, `--json`.

### `confluence blog`
`create | list | view`.

### `confluence space`
`archive | create | list | restore | update | view`.

## Auth

Two distinct surfaces. Global (`acli auth ...`) is OAuth-only in 1.3.18 and has no flags on `login`. Product-scoped (`acli jira auth ...`, `acli confluence auth ...`) carries the `--web`/`--site`/`--email`/`--token` flag matrix. Recipes that hit Jira or Confluence require the matching product-scoped login.

- `acli auth status` — global + per-product auth state. Output lists any products (Jira/Confluence) not yet authenticated.
- `acli auth login <site>.atlassian.net` — global OAuth (positional site, no flags in 1.3.18).
- `acli jira auth login --web` — Jira product OAuth (browser).
- `acli jira auth login --site <site>.atlassian.net --email <you> --token < token.txt` — Jira token flow (stdin).
- `acli confluence auth login --web` — Confluence product OAuth (browser).
- `acli confluence auth login --site <site>.atlassian.net --email <you> --token < token.txt` — Confluence token flow (stdin).
- `acli auth logout` — global logout (OAuth accounts).
- `acli auth switch [--site <s>] [--email <e>]` — switch global account.

## Out of scope

- `rovodev` (Atlassian AI coding agent).
- `admin` commands (org-level operations).
