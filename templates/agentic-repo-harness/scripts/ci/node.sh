#!/usr/bin/env bash
set -euo pipefail

if [[ -f pnpm-lock.yaml ]]; then
  corepack enable
  pnpm install --frozen-lockfile
  runner='pnpm'
elif [[ -f yarn.lock ]]; then
  corepack enable
  yarn install --frozen-lockfile
  runner='yarn'
elif [[ -f package-lock.json ]]; then
  npm ci
  runner='npm'
else
  npm install
  runner='npm'
fi

has_script() {
  node -e "process.exit(require('./package.json').scripts?.[process.argv[1]] ? 0 : 1)" "$1"
}

if has_script test; then "$runner" run test; fi
if has_script build; then "$runner" run build; fi
