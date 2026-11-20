#!/usr/bin/env bash
# Regression test for vaam-apps/.github#17.
#
# The SARIF upload steps in sast.yml and trivy.yml once passed the base64 SARIF
# to jq as `--arg sarif`, which puts it on argv. Past the kernel's argument
# limit execve fails and jq reports "Argument list too long". The payload must
# reach jq on stdin instead.
#
# Two checks:
#   1. Static: no workflow passes SARIF to jq as an argument.
#   2. Behavioural: the stdin pipeline used by the workflows round-trips a
#      payload far larger than the argument limit, byte for byte.
set -euo pipefail

root=$(cd "$(dirname "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Comment lines are dropped and backslash line continuations are joined first,
# so neither a comment nor a split `--arg \` / `sarif` can fool the greps.
normalise() {
  sed -e '/^[[:space:]]*#/d' "$1" | sed -e ':a;/\\$/{N;s/\\\n[[:space:]]*/ /;ta}'
}

echo "check 1: no workflow passes SARIF to jq via an argument"
for w in "$root"/.github/workflows/*.yml; do
  if normalise "$w" | grep -n -E -e '--(arg|argjson|slurpfile|rawfile)[[:space:]]+sarif'; then
    echo "FAIL: $w passes SARIF as a jq argument (see lines above)" >&2
    exit 1
  fi
done
for pair in sast.yml:CodeQL trivy.yml:Trivy; do
  w=${pair%%:*}
  tool=${pair##*:}
  n=$(normalise "$root/.github/workflows/$w")
  if ! grep -q -E 'base64 -w0 \| jq -Rsc' <<<"$n"; then
    echo "FAIL: $w no longer builds the payload with 'base64 -w0 | jq -Rsc'" >&2
    exit 1
  fi
  if ! grep -q -F "sarif:., tool_name:\"$tool\"" <<<"$n"; then
    echo "FAIL: $w payload filter is not '{...sarif:., tool_name:\"$tool\"}'" >&2
    exit 1
  fi
done

echo "check 2: the stdin pipeline round-trips a payload larger than ARG_MAX"
# ARG_MAX is typically 2 MB and a single argument is capped at 128 KB, so 8 MB
# of random data (about 10.7 MB once gzipped, which does not shrink it, and
# base64'd) is well past both.
head -c 8000000 /dev/urandom > "$tmp/in.sarif"

# Prove the test can fail: the old form must hit the limit on this input.
if jq -nc --arg sarif "$(gzip -c "$tmp/in.sarif" | base64 -w0)" '{sarif:$sarif}' \
  >/dev/null 2>&1; then
  echo "FAIL: --arg form unexpectedly succeeded; the input is too small to prove anything" >&2
  exit 1
fi

payload=$(gzip -c "$tmp/in.sarif" | base64 -w0 | jq -Rsc --arg sha abc --arg ref refs/heads/x \
  '{commit_sha:$sha, ref:$ref, sarif:., tool_name:"CodeQL"}')
printf '%s' "$payload" | jq -j .sarif | base64 -d | gunzip | cmp - "$tmp/in.sarif"
[ "$(printf '%s' "$payload" | jq -r .commit_sha)" = abc ]
[ "$(printf '%s' "$payload" | jq -r .tool_name)" = CodeQL ]

echo "ok"
