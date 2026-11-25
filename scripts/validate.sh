#!/usr/bin/env bash
# Validate skills: frontmatter has name + description, name matches the folder, and relative links resolve.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
for f in skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$f")")
  name=$(awk '/^---$/{c++; next} c==1 && /^name:/{sub(/^name:[ ]*/,""); print; exit}' "$f")
  desc=$(awk '/^---$/{c++; next} c==1 && /^description:/{print "ok"; exit}' "$f")
  [ "$name" = "$dir" ] || { echo "ERR $f: name '$name' != folder '$dir'"; fail=1; }
  [ "$desc" = "ok" ] || { echo "ERR $f: missing description"; fail=1; }
done
while IFS= read -r f; do
  base=$(dirname "$f")
  { grep -oE '\]\([^)#]+\.md\)' "$f" || true; } | sed -E 's/^\]\(//; s/\)$//' | while IFS= read -r link; do
    case "$link" in http*) continue;; esac
    [ -f "$base/$link" ] || { echo "ERR $f: broken link $link"; exit 1; }
  done || fail=1
done < <(find skills -name '*.md')
[ $fail -eq 0 ] && echo "OK: $(ls -d skills/*/ | wc -l | tr -d ' ') skills valid"
exit $fail
