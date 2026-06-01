#!/usr/bin/env bash
# Description: On-demand Static Application Security Testing (SAST) scanner core.
set -euo pipefail

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[*] Initializing local Security Vulnerability & Compliance Scan...${NC}"

# Check 1: Scan for hardcoded credentials/secrets in source files
echo -e "[-] Auditing code layers for exposed private signatures..."
if grep -rE '(PASSWORD|SECRET_KEY|PRIVATE_KEY|AUTH_TOKEN)="?[a-zA-Z0-9]{10,}"?' --exclude-dir=node_modules --exclude=.env.example --exclude=*.sh .; then
    echo -e "${RED}[!] WARNING: Potential hardcoded secret leaks detected above!${NC}"
else
    echo -e "${GREEN}[V] No obvious hardcoded secret patterns found in source trees.${NC}"
fi

# Check 2: Audit critical directory execution modes
echo -e "[-] Analyzing file execution permissions..."
BAD_PERMS=$(find scripts/infra/ -type f -not -perm 755 -not -perm 700 | wc -l)
if [ "$BAD_PERMS" -gt 0 ]; then
    echo -e "${YELLOW}[!] NOTICE: $BAD_PERMS engine files have non-standard permissions. Consider resetting to 755.${NC}"
else
    echo -e "${GREEN}[V] Script folder execution privileges look crisp.${NC}"
fi

echo -e "${GREEN}[*] Static Application Security audit phase finalized.${NC}"
