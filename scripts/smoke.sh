#!/usr/bin/env bash
# Verifies that the acli flag surface the recipes and the write-gate depend on is still
# present, and that the negative claims the docs make (page is view-only, some writes have
# no confirm flag) still hold. Pure --help parsing. No tenant I/O. Safe without credentials.

set -euo pipefail

MIN_VER="1.3.36"
VER=$(acli --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
[ -n "$VER" ] || { echo "smoke: cannot parse acli version from 'acli --version'" >&2; exit 1; }
[ "$(printf '%s\n%s\n' "$MIN_VER" "$VER" | sort -V | head -1)" = "$MIN_VER" ] \
  || { echo "smoke: acli >= $MIN_VER required, got $VER" >&2; exit 1; }

fail() { echo "smoke: $*" >&2; exit 1; }

# need FLAG CMD...   — FLAG must appear in `acli CMD... --help`.
need() {
  local flag=$1 help; shift
  help=$(acli "$@" --help 2>&1)
  grep -q -- "$flag" <<<"$help" || fail "expected '$flag' in 'acli $* --help'"
}

# forbid FLAG CMD... — FLAG must NOT appear. Fires when acli grows a flag the docs say is absent.
forbid() {
  local flag=$1 help; shift
  help=$(acli "$@" --help 2>&1)
  if grep -q -- "$flag" <<<"$help"; then
    fail "unexpected '$flag' in 'acli $* --help' — update reference/flags.md and protocols/write-gate.md"
  fi
}

# --- read surface used by the recipes ---
need '--fields'   jira workitem view
need '--json'     jira workitem view
need '--jql'      jira workitem search
need '--paginate' jira workitem search
need '--key'      jira workitem comment list
need '--sprint'   jira sprint list-workitems
need '--board'    jira sprint list-workitems
need '--state'    jira board list-sprints
need '--id'                      confluence page view
need '--body-format'             confluence page view
need '--include-version'         confluence page view
need '--include-labels'          confluence page view
need '--include-direct-children' confluence page view
need '--include-properties'      confluence page view

# --- auth: product-scoped login carries the flag matrix ---
for product in jira confluence; do
  need '--web'   "$product" auth login
  need '--site'  "$product" auth login
  need '--email' "$product" auth login
  need '--token' "$product" auth login
done

# --- write-gate: confirm-flag matrix (reference/flags.md) ---
# -y and --yes
for sub in edit transition assign clone delete archive unarchive; do
  need '-y, --yes' jira workitem "$sub"
done
# --yes only (no -y shorthand)
need '--yes' jira workitem create-bulk
need '--yes' jira workitem link create
need '--yes' jira workitem link delete
# no confirm flag at all — write-gate must not inject one
forbid '--yes' jira workitem create
forbid '--yes' jira workitem comment create
forbid '--yes' jira workitem comment update
forbid '--yes' jira workitem comment delete
forbid '--yes' confluence blog create
for sub in create update archive restore; do
  forbid '--yes' confluence space "$sub"
done

# --- structural negative claims ---
# `confluence page` exposes only `view` (README limitations, write-gate, commands.md).
page_subs=$(acli confluence page --help | sed -n '/^Available Commands/,/^$/p' | awk 'NR>1 && NF {print $1}' | tr '\n' ' ')
[ "$page_subs" = "view " ] || fail "confluence page now exposes: ${page_subs}— update README limitations, write-gate and commands.md"
# no global --output switch (flags.md)
forbid '--output' jira workitem search

echo "acli flag surface matches recipe and write-gate assumptions (version $VER >= $MIN_VER)"
