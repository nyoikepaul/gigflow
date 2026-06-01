#!/usr/bin/env bash
# Description: Hardens the server by configuring UFW (Uncomplicated Firewall) to default-deny.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# SSH Port - default is 22, but parameterizing it is best practice in case you change it later
SSH_PORT=${1:-"22"}

echo -e "${YELLOW}[*] Configuring bare-metal firewall (UFW)...${NC}"

# Reset UFW to default state to ensure a clean slate
sudo ufw --force reset > /dev/null

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow essential ports
echo -e "${GREEN}[*] Opening SSH on port ${SSH_PORT}...${NC}"
sudo ufw allow "${SSH_PORT}/tcp"

echo -e "${GREEN}[*] Opening HTTP/HTTPS ports...${NC}"
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable UFW silently
echo "y" | sudo ufw enable > /dev/null

echo -e "${GREEN}[*] Firewall active. All non-essential ports are now blocked.${NC}"
sudo ufw status numbered
