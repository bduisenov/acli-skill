#!/usr/bin/env bash
# Verifies that the acli flag surface the recipes depend on is still present.
# Pure --help parsing. No tenant I/O. Safe to run without credentials.

set -euo pipefail

MIN_VER="1.3.18"
VER=$(acli --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
[ -n "$VER" ] || { echo "smoke: cannot parse acli version from 'acli --version'" >&2; exit 1; }
[ "$(printf '%s\n%s\n' "$MIN_VER" "$VER" | sort -V | head -1)" = "$MIN_VER" ] \
  || { echo "smoke: acli >= $MIN_VER required, got $VER" >&2; exit 1; }

acli jira workitem view --help | grep -q -- '--fields'
acli jira workitem view --help | grep -q -- '--json'
acli jira workitem search --help | grep -q -- '--jql'
acli jira workitem search --help | grep -q -- '--paginate'
acli jira workitem comment list --help | grep -q -- '--key'
acli jira workitem edit --help | grep -q -- '-y, --yes'
acli jira sprint list-workitems --help | grep -q -- '--sprint'
acli jira sprint list-workitems --help | grep -q -- '--board'
acli jira board list-sprints --help | grep -q -- '--state'
acli confluence page view --help | grep -q -- '--id'
acli confluence page view --help | grep -q -- '--body-format'
acli confluence page view --help | grep -q -- '--include-version'
acli confluence page view --help | grep -q -- '--include-labels'
acli confluence page view --help | grep -q -- '--include-direct-children'
acli confluence page view --help | grep -q -- '--include-properties'

echo "acli flag surface matches recipe assumptions (version $VER >= $MIN_VER)"
