#!/usr/bin/env bash
set -euo pipefail

if [[ -f Cargo.lock ]]; then
  cargo test --all-targets --locked
else
  cargo test --all-targets
fi
