#!/usr/bin/env bash
# Description: Validates required environment variables before build.
set -euo pipefail

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[*] Auditing environment variables...${NC}"

# Define critical variables required for production
REQUIRED_VARS=("DATABASE_URL" "NEXT_PUBLIC_API_URL" "NEXTAUTH_SECRET")

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo -e "${RED}[!] CRITICAL: .env file is missing. Aborting build.${NC}"
    exit 1
fi

# Validate each required variable
MISSING_VARS=0
for VAR in "${REQUIRED_VARS[@]}"; do
    if ! grep -q "^${VAR}=" .env; then
        echo -e "${RED}[!] Missing required variable: ${VAR}${NC}"
        MISSING_VARS=$((MISSING_VARS+1))
    fi
done

if [ "$MISSING_VARS" -gt 0 ]; then
    echo -e "${RED}[!] Environment validation failed. Please populate missing variables.${NC}"
    exit 1
fi

echo -e "${GREEN}[*] Environment validation passed. All systems go.${NC}"
