# Recipe: Sprint state

## Trigger

User asks for "current sprint", "standup snapshot", or "what's in the sprint", given a board ID. If the user only has a board URL, extract the board ID from `rapidView=<ID>` in the URL.

## Precondition

`protocols/auth-preflight.md` has passed for the session.

## Steps

1. **Resolve the active sprint.**

   ```bash
   acli jira board list-sprints --id <BOARD-ID> --state active --json
   ```

   Pick the one active sprint; extract its `id`.

   **Edge case:** more than one active sprint (parallel teams on the same board). Show the list and ask the user which to snapshot before proceeding.

2. **List work items in the sprint.**

   `sprint list-workitems` requires BOTH `--sprint` and `--board`:

   ```bash
   acli jira sprint list-workitems \
     --sprint <SPRINT-ID> \
     --board <BOARD-ID> \
     --fields "key,summary,status,assignee" \
     --paginate \
     --json
   ```

3. **Render grouped by status.**

   ```markdown
   # Sprint <sprint-name> — <sprint-state> (<goal>)

   **Board:** <board-name>  **Ends:** <end-date>

   ## In Progress (<N>)
   | Key | Summary | Assignee |
   |---|---|---|

   ## To Do (<N>)
   ...

   ## Done (<N>)
   ...
   ```

## Output contract

A single-sprint snapshot grouped by status column. No cross-sprint or historical aggregation.
