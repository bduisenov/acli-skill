# Recipe: Confluence page fetch

## Trigger

User provides a Confluence page ID or a page URL. Common URL shapes:

- `https://<site>.atlassian.net/wiki/spaces/<SPACE>/pages/<id>/<slug>`
- `https://<site>.atlassian.net/wiki/spaces/<SPACE>/pages/<id>`

## Precondition

`protocols/auth-preflight.md` has passed for the session.

## Limitation

acli 1.3.18 has no keyword search for pages — this recipe is ID-driven only. See `reference/commands.md` for the full Confluence surface.

## Steps

1. **Normalize input to a page ID.**

   If the input is a URL, extract `<id>` via regex `/pages/(\d+)(/|$)`. Reject input if no match — ask the user for the ID directly.

2. **Fetch the page.**

   ```bash
   acli confluence page view \
     --id <id> \
     --body-format storage \
     --include-version \
     --include-labels \
     --json
   ```

   Flag notes:
   - `--body-format` accepts `storage`, `atlas_doc_format`, or `view`. `storage` is the canonical authoring format; `view` is rendered HTML.
   - Add `--include-direct-children` if the user asks for child pages too.
   - Add `--include-properties` for page-content properties.

3. **Render.**

   ```markdown
   # <page title>

   **Space:** <space-key>  **Version:** v<version>  **Labels:** <labels>  **Last updated:** <when> by <who>

   ---

   <body, as returned by --body-format storage>
   ```

## Output contract

Metadata header + page body. No traversal (unless the user opts in via `--include-direct-children`).
