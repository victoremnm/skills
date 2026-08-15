#!/usr/bin/env bash
set -euo pipefail

readonly IDLE_REPO="/home/vem/homelab"
readonly IDLE_PROMPT="${IDLE_REPO}/.agents/skills/github-idle-maintainer/assets/hourly-prompt.md"
readonly IDLE_LOCK="/tmp/github-idle-maintainer.lock"

exec 9>"${IDLE_LOCK}"
flock -n 9 || exit 0

exec codex exec --cd "${IDLE_REPO}" --ephemeral --model gpt-5.6-luna \
  --sandbox workspace-write --ask-for-approval never - < "${IDLE_PROMPT}"
