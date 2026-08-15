#!/usr/bin/env bash
set -euo pipefail

readonly IDLE_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly IDLE_REPO="${IDLE_REPO:-${PWD}}"
readonly IDLE_MODEL="${IDLE_MODEL:-gpt-5.6-luna}"
readonly IDLE_ORGS="${IDLE_ORGS:?Set IDLE_ORGS to a comma-separated organization list}"
readonly IDLE_PROMPT="${IDLE_SCRIPT_DIR}/../assets/hourly-prompt.md"
readonly IDLE_LOCK="/tmp/github-idle-maintainer-$(id -u).lock"

exec 9>"${IDLE_LOCK}"
flock -n 9 || exit 0

exec codex --ask-for-approval never --model "${IDLE_MODEL}" --sandbox workspace-write \
  --cd "${IDLE_REPO}" exec --ephemeral - < "${IDLE_PROMPT}"
