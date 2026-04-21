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

- `acli auth status` — global auth state across products.
- `acli auth login --web` — browser OAuth (recommended).
- `acli auth login --site <site>.atlassian.net --email <you> --token` — token flow.
- `acli auth logout` — global logout.

## Out of scope

- `rovodev` (Atlassian AI coding agent).
- `admin` commands (org-level operations).
