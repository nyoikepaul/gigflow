#!/usr/bin/env bash
# Description: Detects the active container port and determines the target standby port.
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

PORT_A=3000
PORT_B=3001

echo -e "${BLUE}[*] Auditing live runtime environment...${NC}"

# Check if a container is running on Port A
if docker ps --format '{{.Ports}}' | grep -q "$PORT_A"; then
    CURRENT_PORT=$PORT_A
    TARGET_PORT=$PORT_B
    TARGET_COLOR="Green"
else
    CURRENT_PORT=$PORT_B
    TARGET_PORT=$PORT_A
    TARGET_COLOR="Blue"
fi

echo -e "${GREEN}[*] Active Production Port: ${CURRENT_PORT}${NC}"
echo -e "${GREEN}[*] Standby Target Port allocated for new build: ${TARGET_PORT} (${TARGET_COLOR})${NC}"

# Export variables for downstream orchestration scripts
echo "TARGET_PORT=${TARGET_PORT}" > /tmp/gigflow_next_target.env
