#!/usr/bin/env bash
# Description: Actively polls the target application port to verify stability before routing traffic.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Read targeted port or default to standby
TARGET_PORT=${1:-3001}
MAX_ATTEMPTS=6
WAIT_SECONDS=5

echo -e "${YELLOW}[*] Validating app health on port ${TARGET_PORT}...${NC}"

for ((i=1; i<=MAX_ATTEMPTS; i++)); do
    # Use curl to fetch the HTTP status code quietly
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:"$TARGET_PORT"/ || true)
    
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo -e "${GREEN}[*] Health check passed! Application is responsive (HTTP 200).${NC}"
        exit 0
    fi
    
    echo -e "${YELLOW}[!] Attempt $i/$MAX_ATTEMPTS failed (HTTP $STATUS_CODE). Retrying in ${WAIT_SECONDS}s...${NC}"
    sleep "$WAIT_SECONDS"
done

echo -e "${RED}[!] CRITICAL: Application failed health checks on port ${TARGET_PORT}. Halting swap.${NC}"
exit 1
