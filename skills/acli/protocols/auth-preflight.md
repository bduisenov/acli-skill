# Protocol: Auth preflight

Run this before the first `acli` call in a session. If it fails at any step, stop — do not proceed to a recipe.

## Steps

1. **Version gate.**

   ```bash
   acli --version
   ```

   Parse output of the form `acli version X.Y.Z-<channel>`. Assert `X.Y.Z >= 1.3.18`.

   If acli is missing (`command not found`) or older, stop and print:

   > `acli` must be installed and ≥ 1.3.18. Install guide: https://developer.atlassian.com/cloud/acli/guides/how-to-get-started/

2. **Auth check.**

   ```bash
   acli auth status
   ```

   If the command exits non-zero, surface the stderr line **verbatim** (do not paraphrase). acli's unauthenticated message is:

   > ✗ Error: unauthorized: use 'acli auth login' to authenticate

   If the command succeeds but the output contains a line like:

   > Following apps are not authenticated with your global profile: Jira, Confluence

   then the global OAuth session is present but the product scopes (Jira, Confluence) are not. Recipes that hit Jira/Confluence will fail until those product scopes are authenticated. Treat this as step 3 required for the listed products.

3. **Login guidance (skill does NOT run this).**

   acli 1.3.18 has two distinct auth surfaces, and they do not substitute for each other:

   | Command | Scope | Flags in 1.3.18 |
   |---------|-------|-----------------|
   | `acli auth login <site>.atlassian.net` | Global OAuth | None — positional site only. |
   | `acli jira auth login` | Jira product | `--web`, `--site`, `--email`, `--token`. |
   | `acli confluence auth login` | Confluence product | `--web`, `--site`, `--email`, `--token`. |

   Instruct the user to run the product-scoped login for each product the recipes will touch. Examples:

   ```bash
   # Browser OAuth (recommended):
   acli jira auth login --web
   acli confluence auth login --web

   # Token-based (API token read from stdin):
   acli jira auth login --site <site>.atlassian.net --email <you> --token < token.txt
   acli confluence auth login --site <site>.atlassian.net --email <you> --token < token.txt
   ```

   The bare `acli auth login` global command is OAuth-only in 1.3.18 and accepts no `--web`/`--site`/`--email`/`--token` flags. It is not sufficient on its own for Jira/Confluence recipes; at least one product-scoped login is required.

   Wait for the user to confirm auth before re-running step 2.

4. **Multi-site handling.**

   If `acli auth status` output lists more than one active site, ask the user which site to target for the session. Persist the choice in the conversation; every subsequent recipe call in the session uses it.

5. **Proceed** to the recipe only after steps 1–4 succeed and the target site is confirmed.
