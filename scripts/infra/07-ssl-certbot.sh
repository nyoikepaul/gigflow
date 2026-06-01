#!/usr/bin/env bash
# Description: Automates Let's Encrypt SSL provisioning for the Nginx server block.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN_NAME=${1:-"gigflow.yourdomain.com"}
EMAIL=${2:-"admin@yourdomain.com"}

echo -e "${YELLOW}[*] Initiating SSL provisioning for ${DOMAIN_NAME}...${NC}"

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo -e "${RED}[!] Certbot is not installed. Please install it first (sudo apt install certbot python3-certbot-nginx).${NC}"
    exit 1
fi

# Request the certificate
echo -e "${GREEN}[*] Requesting Let's Encrypt certificate...${NC}"
if sudo certbot --nginx -d "$DOMAIN_NAME" --non-interactive --agree-tos -m "$EMAIL" --redirect; then
    echo -e "${GREEN}[*] SSL Certificate successfully installed and Nginx configured for HTTPS.${NC}"
else
    echo -e "${RED}[!] SSL provisioning failed. Check domain DNS records (A/AAAA).${NC}"
    exit 1
fi
