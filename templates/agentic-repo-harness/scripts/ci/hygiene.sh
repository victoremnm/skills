#!/usr/bin/env bash
set -euo pipefail

if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
  git diff --check HEAD^ HEAD
else
  git diff --check
fi

while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' -print0)

while IFS= read -r -d '' json; do
  jq empty "$json"
done < <(find . -path './.git' -prune -o -name '*.json' -print0)

./scripts/ci/scan-secrets.sh
