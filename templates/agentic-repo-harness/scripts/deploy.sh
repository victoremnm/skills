#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DEPLOY_COMMAND:-}" ]]; then
  echo "No DEPLOY_COMMAND repository variable is configured; deployment skipped."
  exit 0
fi

echo "Running the repository deployment hook."
bash -eo pipefail -c "$DEPLOY_COMMAND"
