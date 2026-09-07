#!/usr/bin/env bash
# Bump a prebuilt formula to a new upstream release: rewrite the versioned
# release-asset urls and recompute each asset's sha256 by downloading the
# asset and hashing it ourselves (never trusting an upstream checksums file).
# Generic for formulas whose stable urls follow the tap shape:
# .../releases/download/<tag>/<asset>, each url line immediately followed by
# its sha256 line. The version may appear v-prefixed in the tag and repeated
# inside the asset name (e.g. .../download/v1.0.12/vfox_1.0.12_...), so the
# rewrite replaces every occurrence of the version on each url line.
#
# Usage: .github/scripts/bump.sh <formula> [<version>]
#   Without <version>: brew livecheck decides the newest upstream release.
#   Exits 0 with changed=false when the formula is already at that version.
# Requires: the repo installed as tap (CI: setup-homebrew). Run from repo root.
# Outputs (also to $GITHUB_OUTPUT when set): version, changed=true|false
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "usage: $0 <formula> [<version>]" >&2
  exit 2
fi

NAME="$1"
WANT="${2:-}"
FILE="Formula/${NAME}.rb"
if [ ! -f "$FILE" ]; then
  echo "error: ${FILE} not found" >&2
  exit 2
fi

if [ -n "${GITHUB_REPOSITORY_OWNER:-}" ]; then
  OWNER="$GITHUB_REPOSITORY_OWNER"
else
  OWNER="$(git remote get-url origin | sed -E 's|.*github.com[:/]([^/]+)/.*|\1|')"
fi
QUALIFIED="${OWNER}/prebuilt/${NAME}"

LIVECHECK_JSON="$(brew livecheck --formula --json "$QUALIFIED")"
CURRENT="$(python3 -c 'import sys,json;print(json.load(sys.stdin)[0]["version"]["current"])' <<<"$LIVECHECK_JSON")"
LATEST="${WANT:-$(python3 -c 'import sys,json;print(json.load(sys.stdin)[0]["version"]["latest"])' <<<"$LIVECHECK_JSON")}"

emit() {
  echo "$1"
  if [ -n "${GITHUB_OUTPUT:-}" ]; then echo "$1" >> "$GITHUB_OUTPUT"; fi
}

if [ "$CURRENT" = "$LATEST" ]; then
  echo "${NAME} already at ${LATEST}"
  emit "version=${LATEST}"
  emit "changed=false"
  exit 0
fi
echo "bumping ${NAME}: ${CURRENT} -> ${LATEST}"

export FILE CURRENT LATEST
NEW_URLS="$(python3 - <<'PY'
import os, re
path = os.environ["FILE"]
cur, new = os.environ["CURRENT"], os.environ["LATEST"]
lines = open(path).read().splitlines(keepends=True)
changed = 0
for i, line in enumerate(lines):
    if re.search(r'url "[^"]*/releases/download/[^"]*"', line) and cur in line:
        lines[i] = line.replace(cur, new)
        changed += 1
if not changed:
    raise SystemExit(f"no release-asset url containing {cur} found in {path}")
text = "".join(lines)
open(path, "w").write(text)
for m in re.finditer(r'url "([^"]+/releases/download/[^"]+)"', text):
    print(m.group(1))
PY
)"

while read -r url; do
  TMP="$(mktemp)"
  echo "downloading ${url}"
  curl -fsSL "$url" -o "$TMP"
  SHA="$(shasum -a 256 "$TMP" | cut -d' ' -f1)"
  rm -f "$TMP"
  URL="$url" SHA="$SHA" python3 - <<'PY'
import os
path, url, sha = os.environ["FILE"], os.environ["URL"], os.environ["SHA"]
lines = open(path).read().splitlines(keepends=True)
for i, line in enumerate(lines):
    if f'url "{url}"' in line:
        target = i + 1
        if "sha256" not in lines[target]:
            raise SystemExit(f"line after url {url} is not a sha256 line")
        indent = lines[target][:len(lines[target]) - len(lines[target].lstrip())]
        lines[target] = f'{indent}sha256 "{sha}"\n'
        break
else:
    raise SystemExit(f"url {url} not found in {path}")
open(path, "w").write("".join(lines))
PY
done <<<"$NEW_URLS"

echo "updated ${FILE}"
emit "version=${LATEST}"
emit "changed=true"
