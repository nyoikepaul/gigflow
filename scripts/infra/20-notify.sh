#!/usr/bin/env bash
# Description: Reusable notifications wrapper to route messages to external chat webhooks.
set -euo pipefail

RED='\033[0;31m'
NC='\033[0m'

# Fallback to an environment variable if no webhook URL is passed explicitly
WEBHOOK_URL="${GIGFLOW_WEBHOOK_URL:-""}"
MESSAGE="${1:-"GigFlow Alert: No message body provided."}"

if [[ -z "$WEBHOOK_URL" ]]; then
    echo -e "${RED}[!] Alert muted: GIGFLOW_WEBHOOK_URL environment variable is not set.${NC}"
    exit 0
fi

# Generate JSON payload and dispatch via curl
JSON_PAYLOAD=$(printf '{"text": "%s"}' "$MESSAGE")

curl -s -X POST -H "Content-Type: application/json" \
     -d "$JSON_PAYLOAD" \
     "$WEBHOOK_URL" > /dev/null

echo "[*] External webhook alert dispatched successfully."
