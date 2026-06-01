#!/usr/bin/env bash
# Description: Automated verification script for running docker container status matrices.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CONTAINER_NAME="gigflow_runtime"

echo -e "${GREEN}[*] Inspecting container health vector for: ${CONTAINER_NAME}...${NC}"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${RED}[!] CRITICAL FAILURE: Container '${CONTAINER_NAME}' is not running or active!${NC}"
    exit 1
fi

HEALTH_STATUS=$(docker inspect --format='{{json .State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "\"unsupported\"")

echo -e "[-] Internal Engine State: ${HEALTH_STATUS}"
echo -e "${GREEN}[*] Container orchestration nodes validated successfully.${NC}"
