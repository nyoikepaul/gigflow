#!/usr/bin/env bash
# Description: Definitive master pipeline execution runner.
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="scripts/infra"

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}     LAUNCHING GIGFLOW ZERO-DOWNTIME ENGINE    ${NC}"
echo -e "${BLUE}===============================================${NC}"

# 1. Enforce single deployment runtime
source "${SCRIPT_DIR}/10-deploy-lock.sh"

# 2. Validate environment configs
source "${SCRIPT_DIR}/01-env-validate.sh"

# 3. Trigger pre-flight test suites
source "${SCRIPT_DIR}/02-test-runner.sh"

# 4. Allocate dynamic blue/green routing ports
source "${SCRIPT_DIR}/12-port-allocator.sh"
source /tmp/gigflow_next_target.env

# 5. Build current code snapshot
source "${SCRIPT_DIR}/03-docker-build.sh"

# 6. Instantiate new container instance on target standby port
SHORT_SHA=$(git rev-parse --short HEAD)
echo -e "${BLUE}[*] Starting container on port ${TARGET_PORT}...${NC}"
docker run -d --name "gigflow-${TARGET_PORT}-${SHORT_SHA}" -p "${TARGET_PORT}:3000" --env-file .env gigflow-app:latest > /dev/null

# 7. Execute exponential backoff health checks
if ! "${SCRIPT_DIR}/11-health-check.sh" "$TARGET_PORT"; then
    echo -e "${RED}[!] Deployment failed health validation. Rolling back...${NC}"
    docker stop "gigflow-${TARGET_PORT}-${SHORT_SHA}" > /dev/null && docker rm "gigflow-${TARGET_PORT}-${SHORT_SHA}" > /dev/null
    exit 1
fi

# 8. Hot-swap live reverse-proxy traffic
source "${SCRIPT_DIR}/13-nginx-swap.sh"

# 9. Clean legacy architecture and clear cache
source "${SCRIPT_DIR}/14-container-purge.sh"
source "${SCRIPT_DIR}/04-docker-clean.sh"

echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}  DEPLOYMENT SUCCESSFUL - ZERO DOWNTIME MET    ${NC}"
echo -e "${GREEN}===============================================${NC}"
