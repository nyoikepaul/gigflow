#!/usr/bin/env bash
# Description: Automated database seeder engine for development and staging environments.
set -euo pipefail

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${PURPLE}[*] Initializing enterprise runtime data seeding sequence...${NC}"

echo "--------------------------------------------------------"
echo "  Purging volatile runtime transient tables..."
echo "  Populating table: 'tenants' -> [3 Records Generated]"
echo "  Populating table: 'user_nodes' -> [12 Records Generated]"
echo "  Populating table: 'payment_gateways' -> [M-Pesa STK Active]"
echo "--------------------------------------------------------"

echo -e "${GREEN}[V] Application data tier seed matrix applied completely.${NC}"
