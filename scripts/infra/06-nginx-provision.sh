#!/usr/bin/env bash
# Description: Dynamically generates an optimized Nginx server block for GigFlow.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN_NAME=${1:-"gigflow.yourdomain.com"}
PORT=${2:-"3000"}
OUTPUT_FILE="gigflow.nginx.conf"

echo -e "${GREEN}[*] Generating Nginx configuration for ${DOMAIN_NAME}...${NC}"

cat <<EOF > "$OUTPUT_FILE"
# Nginx Configuration for GigFlow
# Generated via automated deployment script

limit_req_zone \$binary_remote_addr zone=gigflow_limit:10m rate=10r/s;

server {
    listen 80;
    server_name ${DOMAIN_NAME};

    # Gzip compression for faster frontend delivery
    gzip on;
    gzip_proxied any;
    gzip_comp_level 4;
    gzip_types text/css application/javascript image/svg+xml;

    location / {
        proxy_pass http://127.0.0.1:${PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        
        # Real IP Forwarding
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Protect API routes with rate limiting
    location /api/ {
        limit_req zone=gigflow_limit burst=20 nodelay;
        proxy_pass http://127.0.0.1:${PORT};
        proxy_set_header Host \$host;
    }
}
EOF

echo -e "${GREEN}[*] Nginx configuration generated at ./${OUTPUT_FILE}${NC}"
echo -e "${GREEN}[*] To apply on server: sudo cp ${OUTPUT_FILE} /etc/nginx/sites-available/ && sudo ln -s /etc/nginx/sites-available/${OUTPUT_FILE} /etc/nginx/sites-enabled/${NC}"
