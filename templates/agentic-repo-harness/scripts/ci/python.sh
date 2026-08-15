#!/usr/bin/env bash
set -euo pipefail

python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip

for requirements in requirements*.txt; do
  [[ -e "$requirements" ]] && .venv/bin/pip install -r "$requirements"
done
if [[ -f pyproject.toml ]]; then .venv/bin/pip install .; fi
if .venv/bin/python -c 'import pytest' 2>/dev/null; then .venv/bin/python -m pytest; fi
