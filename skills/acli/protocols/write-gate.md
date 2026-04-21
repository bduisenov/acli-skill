# Protocol: Write-gate

## Rule reference

This protocol exists to respect the user's personal rule (verbatim):

> **Never edit Jira fields directly — not via Playwright, not via API, not via any other mechanism.** Treat Jira as read-only for writes. Reads are fine. If the user insists on a direct edit, double-check explicitly before touching any write action.

The protocol extends the same discipline to Confluence writes for symmetry. The first write attempt in any session surfaces this one-line reminder in the confirm prompt:

> Reminder: writes are gated per your jira-readonly rule.

## Write subcommands covered

Jira: `workitem create | edit | transition | delete | archive | unarchive | assign | clone | link | create-bulk`.
Jira comments: `workitem comment create | update | delete`.
Confluence (acli 1.3.18): `blog create`, `space create | update | archive | restore`. `page` exposes only `view` at 1.3.18 — no page writes exist yet.

## Steps (non-destructive writes)

0. **Precheck — route to carve-out if the composed command matches any of:**
   - subcommand in the destructive list below, OR
   - argv contains `--jql` or `--filter` (bulk by JQL / filter ID), OR
   - `workitem edit` with `--jql` or `--filter` (bulk edit; a single `-y` silently applies to every matched item).

   When any condition matches, skip the rest of this section and apply the **Destructive carve-out** flow instead (no `-y` injection, copy-paste only).

1. **Compose the command with `-y/--yes` appended.** `acli` 1.3.18 prompts interactively on write subcommands by default, and the Claude Code `Bash` tool has no interactive stdin; without `-y` the call hangs until timeout.
2. **Show the user** the exact command, including `-y`.
3. **If the payload uses `--from-json`**, write it to a unique temp path:

   ```bash
   /tmp/acli-payload-<topic>-<timestamp>.json
   ```

   Example: `/tmp/acli-payload-rca123-edit-20260421-091533.json`. The unique path avoids the zsh `noclobber` silent-stale-file trap, where `cat > /tmp/foo.json <<EOF` is rejected if `/tmp/foo.json` already exists and the subsequent `--from-json` read picks up stale content. Show the file contents in the message before exec.

4. **Ask**: `Execute? (y/N)`.
5. **On `y`:** run the composed command. **On `n` or ambiguous:** abort and print the exact command as copy-pasteable text for manual run.

## Destructive carve-out (no auto-exec)

The skill does NOT auto-append `-y` for the following. Copy-paste only.

- `workitem delete`, `workitem archive`
- `workitem create-bulk`
- Any write targeting `--jql` or `--filter` (bulk by JQL / filter ID)
- `space archive` (irreversible without `space restore`)

Ambiguous write requests (user did not use an explicit write verb) also fall back to copy-paste.

## After execution

Surface the acli exit status and output verbatim. On non-zero exit, do not retry — report and stop.
