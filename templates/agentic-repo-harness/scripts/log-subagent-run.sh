#!/usr/bin/env bash
set -euo pipefail

session_id="${HARNESS_SESSION_ID:-local-$(date +%Y%m%d)}"
agent_id="${1:-unknown}"
agent_type="${2:-subagent}"
model="${3:-unknown}"
latency_ms="${4:-0}"
result="${5:-unknown}"
spool='.harness/telemetry/subagent-runs.ndjson'

mkdir -p "$(dirname "$spool")"
jq -nc \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg session_id "$session_id" \
  --arg agent_id "$agent_id" \
  --arg agent_type "$agent_type" \
  --arg model "$model" \
  --argjson latency_ms "$latency_ms" \
  --arg result_preview "${result:0:300}" \
  '{ts:$ts,session_id:$session_id,agent_id:$agent_id,agent_type:$agent_type,model:$model,latency_ms:$latency_ms,result_preview:$result_preview}' \
  >> "$spool"

echo "Logged subagent run to $spool"
