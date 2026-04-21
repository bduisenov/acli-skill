# Reference: JQL snippets

All snippets target `acli jira workitem search --jql '<query>' --fields '...' --paginate --json`.

## Children of an epic

**Modern Jira schema (primary):**

```
parent = <EPIC-KEY>
```

**Legacy Epic Link (fallback — do not chain silently):**

```
"Epic Link" = <EPIC-KEY>
```

Both are documented so `epic-breakdown.md` can ask the user before retrying with the legacy field on empty results.

## RCA tickets open

```
project = RCA AND statusCategory != Done ORDER BY created DESC
```

## My open tickets

```
assignee = currentUser() AND statusCategory != Done
```

## Recently updated in a project

```
project = <KEY> AND updated >= -7d
```

## Linked incident tickets of an RCA

```
issue in linkedIssues(<RCA-KEY>)
```

## Pull request-linked tickets

```
development[pullrequests].all > 0
```

## Sprint-scoped search (alternative to `sprint list-workitems`)

```
sprint in openSprints() AND assignee = currentUser()
```

## Quoting

Use single quotes around the JQL value in bash to avoid shell interpolation. Inside the JQL string, Jira field names with spaces (e.g. `Epic Link`) are quoted with double quotes — the outer single quotes let the inner doubles pass through literally.
