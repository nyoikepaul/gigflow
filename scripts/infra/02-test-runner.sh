#!/usr/bin/env bash
# Description: Executes test suites and prevents builds on failure.
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[*] Initializing pre-flight test sequence...${NC}"

# Assuming npm, swap to pnpm/yarn if that's what gigflow uses
echo -e "${YELLOW}[*] Running unit tests (Vitest)...${NC}"
if ! npm run test; then
    echo -e "${RED}[!] Unit tests failed. Halting deployment pipeline.${NC}"
    exit 1
fi

# Uncomment if e2e tests are configured
# echo -e "${YELLOW}[*] Running E2E tests (Playwright)...${NC}"
# if ! npm run test:e2e; then
#     echo -e "${RED}[!] E2E tests failed. Halting deployment pipeline.${NC}"
#     exit 1
# fi

echo -e "${GREEN}[*] All tests passed. The codebase is stable.${NC}"
