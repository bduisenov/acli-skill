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

3. **Login guidance (skill does NOT run this).**

   Instruct the user to run one of:

   ```bash
   acli auth login --web
   # or token-based:
   acli auth login --site <site>.atlassian.net --email <you> --token
   ```

   Wait for the user to confirm auth before re-running step 2.

4. **Multi-site handling.**

   If `acli auth status` output lists more than one active site, ask the user which site to target for the session. Persist the choice in the conversation; every subsequent recipe call in the session uses it.

5. **Proceed** to the recipe only after steps 1–4 succeed and the target site is confirmed.
