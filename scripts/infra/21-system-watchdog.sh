#!/usr/bin/env bash
# Description: Periodic watchdog to monitor app uptime and trigger alert dispatches.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

APP_URL=${1:-"http://127.0.0.1:3000"}
SCRIPT_DIR="scripts/infra"

echo -e "${GREEN}[*] Guard Dog initiating active app health check sequence...${NC}"

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL" || echo "000")

if [ "$STATUS_CODE" -ne 200 ]; then
    ALERT_MSG="🚨 CRITICAL ALERT: GigFlow instance down or returning invalid status code ($STATUS_CODE) on $APP_URL!"
    echo -e "${RED}[!] App target unresponsive. Dispatching notifications...${NC}"
    
    if [[ -f "${SCRIPT_DIR}/20-notify.sh" ]]; then
        bash "${SCRIPT_DIR}/20-notify.sh" "$ALERT_MSG"
    fi
    exit 1
else
    echo -e "${GREEN}[*] Target endpoint healthy (HTTP 200). Systems nominal.${NC}"
fi
