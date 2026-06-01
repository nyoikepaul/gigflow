#!/usr/bin/env bash
# Description: Automated production log stream analysis and error aggregation core.
set -euo pipefail

CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="runtime.log"

echo -e "${CYAN}[*] Initializing telemetry stream parsing engine...${NC}"

# Generate a mock stream if no live app log is present for testing
if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "${YELLOW}[!] Target stream '${LOG_FILE}' absent. Generating operational mock telemetry...${NC}"
    cat << 'MOCK' > "$LOG_FILE"
2026-06-01T14:22:01Z [INFO] - GET /api/v1/health - 200 OK - 12ms
2026-06-01T14:22:15Z [WARN] - POST /api/v1/auth/token - 401 Unauthorized - 45ms
2026-06-01T14:23:02Z [INFO] - GET /api/v1/users/profile - 200 OK - 8ms
2026-06-01T14:23:44Z [ERROR] - POST /api/v1/payments/stk - 500 Internal Server Error - DB Timeout Connection Refused
2026-06-01T14:24:10Z [INFO] - GET /api/v1/metrics - 200 OK - 15ms
MOCK
fi

echo -e "[-] Executing metric extractions against localized log streams:"
echo "--------------------------------------------------------"
TOTAL_ERRORS=$(grep -c "\[ERROR\]" "$LOG_FILE" || echo 0)
TOTAL_WARNS=$(grep -c "\[WARN\]" "$LOG_FILE" || echo 0)
SUCCESS_REQS=$(grep -c "200 OK" "$LOG_FILE" || echo 0)

echo -e "    • Total Critical Exceptions : ${RED}${TOTAL_ERRORS}${NC}"
echo -e "    • Total Security Warnings   : ${YELLOW}${TOTAL_WARNS}${NC}"
echo -e "    • Total Nominal Handshakes  : ${CYAN}${SUCCESS_REQS}${NC}"
echo "--------------------------------------------------------"

if [ "$TOTAL_ERRORS" -gt 0 ]; then
    echo -e "${RED}[!] ALERT: Severe anomalies captured in current log slice:${NC}"
    grep "\[ERROR\]" "$LOG_FILE"
else
    echo -e "${CYAN}[V] Log stream analysis clear. No operational critical errors flagged.${NC}"
fi
