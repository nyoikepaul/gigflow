#!/usr/bin/env bash
# Description: Prevents concurrent deployment runs using a strict file-locking mechanism.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOCK_FILE="/tmp/gigflow_deploy.lock"

echo -e "${GREEN}[*] Checking for concurrent deployment locks...${NC}"

# Open the lock file descriptor
exec 200>"$LOCK_FILE"

# Attempt an exclusive, non-blocking lock
if ! flock -n 200; then
    echo -e "${RED}[!] CRITICAL: Another instance of the deployment pipeline is currently running.${NC}"
    echo -e "${RED}[!] Exiting to prevent system state corruption.${NC}"
    exit 1
fi

echo -e "${GREEN}[*] Lock acquired cleanly. Processing deployment...${NC}"

# Simulate keeping the lock open for sourcing or orchestration
# In the master runner, the lock persists until the script exits or descriptor closes
