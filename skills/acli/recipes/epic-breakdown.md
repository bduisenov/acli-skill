# Recipe: Epic breakdown

## Trigger

User asks to "break down", "list children of", or "show the work under" an epic, given the epic's Jira key.

## Precondition

`protocols/auth-preflight.md` has passed for the session.

## Steps

1. **Fetch the epic header.**

   ```bash
   acli jira workitem view <EPIC-KEY> \
     --fields "key,summary,status,description,assignee" \
     --json
   ```

2. **List children via modern JQL `parent = <EPIC>`.**

   ```bash
   acli jira workitem search \
     --jql 'parent = <EPIC-KEY>' \
     --fields "key,summary,status,assignee,issuetype" \
     --paginate \
     --json
   ```

3. **Fallback (explicit — not silent).** If step 2 returns zero children, do NOT retry automatically. Ask the user:

   > No children found via `parent = <EPIC-KEY>`. Retry with the legacy `"Epic Link"` field, or treat the epic as empty?

   On user consent:

   ```bash
   acli jira workitem search \
     --jql '"Epic Link" = <EPIC-KEY>' \
     --fields "key,summary,status,assignee,issuetype" \
     --paginate \
     --json
   ```

   Empty epics are valid — a silent fallback would mask them.

4. **Render.**

   ```markdown
   # <EPIC-KEY> — <epic summary>

   **Status:** <status>  **Owner:** <assignee>

   <description excerpt>

   ## Children (<N>)

   ### In Progress
   | Key | Summary | Assignee | Type |
   |---|---|---|---|

   ### To Do
   ...

   ### Done
   ...
   ```

## Output contract

Epic header + children grouped by status column. Snippets for both JQL forms are in `reference/jql-snippets.md`.
