#!/usr/bin/env bash
# Description: Detects and kills legacy containers post-traffic swapper.
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ENV_FILE="/tmp/gigflow_next_target.env"
source "$ENV_FILE"

# If our new target was 3001, old container is on 3000 (and vice-versa)
if [ "$TARGET_PORT" -eq 3001 ]; then
    OLD_PORT=3000
else
    OLD_PORT=3001
fi

echo -e "${BLUE}[*] Searching for legacy production containers on port ${OLD_PORT}...${NC}"

# Locate container ID bound to the old port
OLD_CONTAINER_ID=$(docker ps --filter "publish=${OLD_PORT}" --format "{{.ID}}" || true)

if [ -n "$OLD_CONTAINER_ID" ]; then
    echo -e "${BLUE}[*] Stopping legacy container: ${OLD_CONTAINER_ID}${NC}"
    docker stop "$OLD_CONTAINER_ID" > /dev/null
    docker rm "$OLD_CONTAINER_ID" > /dev/null
    echo -e "${GREEN}[*] Legacy infrastructure cleanly decommissioned.${NC}"
else
    echo -e "${GREEN}[*] No legacy containers detected on port ${OLD_PORT}. Clean run.${NC}"
fi
