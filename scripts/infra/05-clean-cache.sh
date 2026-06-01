#!/usr/bin/env bash
# Description: Clears Next.js build cache to ensure pristine production builds.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CACHE_DIR=".next"

echo -e "${GREEN}[*] Checking for existing Next.js build cache...${NC}"

if [ -d "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"
    echo -e "${GREEN}[*] Next.js build directory ($CACHE_DIR) successfully purged.${NC}"
else
    echo -e "${GREEN}[*] No existing cache found. Ready for fresh build.${NC}"
fi
