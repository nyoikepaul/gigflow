#!/usr/bin/env bash
# Description: Prunes dangling Docker images to prevent disk space exhaustion.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[*] Initiating Docker cleanup protocol...${NC}"

# Remove dangling images (images that have no tag and are not referenced by any container)
if docker image prune -f > /dev/null; then
    echo -e "${GREEN}[*] Dangling Docker images successfully purged.${NC}"
else
    echo -e "${YELLOW}[!] No dangling images found or cleanup failed.${NC}"
fi

# Optional: Output current disk usage for Docker
echo -e "${GREEN}[*] Current Docker disk usage:${NC}"
docker system df
