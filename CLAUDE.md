# acli-skill

## What This Is

Claude Code plugin that wraps the Atlassian CLI (`acli`) with workflow recipes for reading Jira work items and Confluence pages, plus a gated write protocol. Solo project. Distributed via a GitHub-sourced marketplace.

## Stack

- **Runtime**: Claude Code skill (Markdown + bash). No build step.
- **External CLI**: `acli` 1.3.36+ (Atlassian Cloud only — no DC/Server).
- **Manifests**: `.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`.

## Repo Shape

```
skills/acli/
  SKILL.md                  # entrypoint + trigger description (authoritative)
  protocols/
    auth-preflight.md       # runs first every session; version + auth status gate
    write-gate.md           # mandatory wrapper for every Jira/Confluence write
  recipes/                  # one file per user workflow
  reference/
    commands.md             # subcommand inventory (verified against 1.3.36)
    flags.md                # per-subcommand flag matrix
    jql-snippets.md         # canonical JQL
scripts/smoke.sh            # acli --help parsing; catches upstream flag drift
```

## Install / Test Locally

```bash
# In Claude Code, from this repo's checkout root:
/plugin marketplace add $(pwd)
/plugin install acli@acli-skill
/reload-plugins
```

Public install (after PR merges to `main`): `/plugin marketplace add bduisenov/acli-skill` then `/plugin install acli@acli-skill`. Marketplace slug = `marketplace.json:name`, NOT `<owner>-<repo>` (verified empirically this session).

## Conventions

- **Recipes are read-only.** Every write goes through `protocols/write-gate.md` — no exceptions, no shortcuts.
- **Auto-triggers fire for reads only.** Writes require an explicit English verb (edit, create, transition, delete, assign, archive, clone, link) in the user's request.
- **Skill never runs `acli auth login`.** Only `acli auth status`. Auth is the user's responsibility.
- **SKILL.md is the authoritative trigger list.** README mirrors it; keep them in sync.
- **Primary-source verification.** Any claim about acli flag/subcommand behavior must be verified via `acli <cmd> --help`, not assumed.

## acli 1.3.36 Gotchas (easy to get wrong)

- `jira workitem comment list` uses `--key`, NOT `--work-item`.
- `jira sprint list-workitems` requires BOTH `--sprint` AND `--board`.
- `confluence page` exposes ONLY `view` at 1.3.36. No `create`/`update`/`delete`.
- `confluence space` has NO `delete` — only `archive`/`restore`.
- Default `jira workitem view` fields exclude `issuelinks`. Pass `--fields` explicitly when linked issues matter.
- `--yes` is per-subcommand, not universal. `edit|transition|assign|clone|delete|archive|unarchive` take `-y/--yes`; `create-bulk`, `link create`, `link delete` take `--yes` only (no `-y`); `workitem create`, `comment create|update|delete`, and every Confluence write take NEITHER — injecting one fails with `unknown flag`. Write-gate appends the long form `--yes` where it exists (Claude Code's `Bash` has no stdin for the prompt) and nothing elsewhere. EXCEPT bulk writes (`--jql`/`--filter`) and the destructive carve-out (`delete`, `archive`, `create-bulk`) — copy-paste only.
- `workitem link` is a group (`create|delete|list|type`), not a leaf subcommand.
- `board get` is deprecated; use `board view --id`.

## Development Workflow

After touching any recipe, protocol, or reference doc:

```bash
./scripts/smoke.sh
```

Pure `--help` parsing. No tenant I/O. Safe without credentials. Fails loudly on a version-floor regression, a missing flag, or a flag appearing where the docs say there is none.

## Important Constraints

- **Never leak private rule names** (`feedback_*`) into committed files. User rules are internal. Rationalize content from public principles.
- **No tenant-specific references** (real Jira keys, Confluence page IDs, site names) in committed files. Use placeholders (`<EPIC-KEY>`, `<KEY>`, `<site>`).
- **Version pin = `acli 1.3.36`.** Bump only when `smoke.sh` verifies new-version flag surface still satisfies recipes. Update README + SKILL.md together. To diff a release against the pin, older binaries are at `https://acli.atlassian.com/darwin/<X.Y.Z>-stable/acli_<X.Y.Z>-stable_darwin_arm64.tar.gz` (also `linux/`, `amd64`); dump `--help` for the same command list from both and `diff -ru`.
- **PR structure**: What / Why / How sections. Include a Test plan.
