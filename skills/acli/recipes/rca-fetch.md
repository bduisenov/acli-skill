# Recipe: RCA ticket fetch

## Trigger

User mentions an RCA-* key or asks for the context of an RCA ticket. Also applies to any Jira key when the user wants "full context" (body + comments + links).

## Precondition

`protocols/auth-preflight.md` has passed for the session.

## Steps

1. **Fetch the ticket with linked-issue metadata.**

   ```bash
   acli jira workitem view <KEY> \
     --fields "key,issuetype,summary,status,assignee,description,issuelinks,labels,priority" \
     --json
   ```

   Notes:
   - Default `view` fields do NOT include `issuelinks`; the explicit `--fields` list above adds it.
   - `comments` is fetched separately (step 2) so pagination works.

2. **Fetch comments, chronological.**

   ```bash
   acli jira workitem comment list --key <KEY> --paginate --json
   ```

   Notes:
   - The comment subcommand's key flag is `--key`, NOT `--work-item`.
   - Default `--order` is `+created` (ascending); no extra sort.

3. **Fetch linked-issue headers (cap at 10).**

   For each entry in step 1's `issuelinks` array, up to 10:

   ```bash
   acli jira workitem view <LINKED-KEY> --fields "key,summary,status" --json
   ```

4. **Merge and present.**

   Output shape:

   ```markdown
   # <KEY> — <summary>

   **Status:** <status>  **Assignee:** <assignee>  **Priority:** <priority>  **Labels:** <labels>

   ## Description

   <description, rendered as-is>

   ## Linked issues

   | Key | Summary | Status | Link type |
   |---|---|---|---|
   | <linked-key> | <linked-summary> | <linked-status> | <inward-or-outward> |

   ## Comments (chronological, newest last)

   ### <author> — <created>

   <body>
   ```

## Output contract

One markdown document containing summary header, description, linked-issues table, and chronological comments. No external fetches.

## Write extension

To edit the ticket, follow `protocols/write-gate.md` — e.g. `acli jira workitem edit --key <KEY> --labels '<label>' -y`.
