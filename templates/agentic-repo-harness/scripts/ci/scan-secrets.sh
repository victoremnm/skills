#!/usr/bin/env bash
set -euo pipefail

matches="$(rg -n --hidden \
  --glob '!.git/**' \
  --glob '!scripts/ci/scan-secrets.sh' \
  --glob '!.env.example' \
  '(-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,})' \
  . || true)"

if [[ -n "$matches" ]]; then
  echo "Potential credential material found:" >&2
  echo "$matches" >&2
  exit 1
fi
