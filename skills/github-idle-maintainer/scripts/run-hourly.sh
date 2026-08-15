#!/usr/bin/env bash
set -euo pipefail

readonly IDLE_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly IDLE_REPO="${IDLE_REPO:-${PWD}}"
readonly IDLE_MODEL="${IDLE_MODEL:-gpt-5.6-luna}"
readonly IDLE_ORGS="${IDLE_ORGS:?Set IDLE_ORGS to a comma-separated organization list}"
readonly IDLE_PROMPT="${IDLE_SCRIPT_DIR}/../assets/hourly-prompt.md"
readonly IDLE_COLLECTOR="${IDLE_SCRIPT_DIR}/collect_github_readonly.py"
readonly IDLE_LOCK="/tmp/github-idle-maintainer-$(id -u).lock"

exec 9>"${IDLE_LOCK}"
flock -n 9 || exit 0

IDLE_SNAPSHOT="$(mktemp /tmp/github-idle-maintainer-snapshot.XXXXXX.json)"
readonly IDLE_SNAPSHOT
trap 'rm -f "${IDLE_SNAPSHOT}"' EXIT

IDLE_ORGS="${IDLE_ORGS}" python3 "${IDLE_COLLECTOR}" > "${IDLE_SNAPSHOT}"

{
  cat "${IDLE_PROMPT}"
  printf '\n\n<github_snapshot>\n'
  cat "${IDLE_SNAPSHOT}"
  printf '</github_snapshot>\n'
} | exec codex --disable apps --ask-for-approval never --model "${IDLE_MODEL}" \
  --sandbox read-only --cd "${IDLE_REPO}" exec --ephemeral -
