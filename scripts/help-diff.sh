#!/usr/bin/env bash
# Diffs the full `--help` tree of the installed acli against another release (default: the
# pinned MIN_VER from smoke.sh). Use it when a new acli ships: an empty diff means the command
# and flag surface is unchanged. Downloads the other release from acli.atlassian.com into a
# temp dir. No tenant I/O. Hidden commands (absent from "Available Commands", e.g. `completion`
# at 1.3.36) are invisible to it; smoke.sh checks the skill's commands by name instead.
#
#   ./scripts/help-diff.sh [X.Y.Z]
#
# Exit: 0 identical, 1 differences (diff on stdout), 2 error.

set -uo pipefail

here=$(cd "$(dirname "$0")" && pwd)
old=${1:-$(sed -n 's/^MIN_VER="\(.*\)"$/\1/p' "$here/smoke.sh")}
[ -n "$old" ] || { echo "help-diff: no version given and MIN_VER not found in smoke.sh" >&2; exit 2; }

os=$(uname -s | tr '[:upper:]' '[:lower:]')
case $(uname -m) in arm64|aarch64) arch=arm64 ;; x86_64) arch=amd64 ;; *) echo "help-diff: unsupported arch $(uname -m)" >&2; exit 2 ;; esac

tmp=$(mktemp -d)
trap '/bin/rm -rf "$tmp"' EXIT

name="acli_${old}-stable_${os}_${arch}"
curl -sSfL "https://acli.atlassian.com/${os}/${old}-stable/${name}.tar.gz" -o "$tmp/acli.tgz" \
  || { echo "help-diff: download of $old failed (some releases return 403)" >&2; exit 2; }
mkdir "$tmp/old" && tar xzf "$tmp/acli.tgz" -C "$tmp/old" || exit 2
old_bin=$(find "$tmp/old" -type f -name acli | head -1)
[ -x "$old_bin" ] || { echo "help-diff: no acli binary in $name.tar.gz" >&2; exit 2; }

# dump BIN DIR [CMD...] — write `BIN CMD... --help` to DIR, then recurse into its subcommands.
dump() {
  local bin=$1 dir=$2 help sub; shift 2
  help=$("$bin" "$@" --help 2>&1)
  printf '%s\n' "$help" > "$dir/$(IFS=_; echo "${*:-root}").txt"
  for sub in $(printf '%s\n' "$help" | sed -n '/^Available Commands/,/^$/p' | awk 'NR>1 && NF {print $1}'); do
    [ "$sub" = help ] || dump "$bin" "$dir" "$@" "$sub"
  done
}

new_ver=$(acli --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
mkdir "$tmp/$old" "$tmp/$new_ver"
dump "$old_bin" "$tmp/$old"
dump acli "$tmp/$new_ver"

n=$(find "$tmp/$new_ver" -name '*.txt' | wc -l | tr -d ' ')
cd "$tmp" && /usr/bin/diff -ru "$old" "$new_ver"
rc=$?
[ "$rc" -eq 0 ] && echo "help-diff: $old and $new_ver --help identical across $n commands" >&2
exit "$rc"
