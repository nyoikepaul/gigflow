#!/usr/bin/env bash
# Description: Provisions logrotate configs to manage container and system log footprint.
set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

OUTPUT_FILE="gigflow.logrotate"

echo -e "${GREEN}[*] Structuring automated log rotation matrix...${NC}"

cat <<EOF > "$OUTPUT_FILE"
# Logrotate rule configuration for GigFlow application deployments
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    maxsize 50M
    missingok
    notifempty
    compress
    delaycompress
    copytruncate
}
EOF

echo -e "${GREEN}[*] Logrotate configuration generated at ./${OUTPUT_FILE}${NC}"
echo -e "${GREEN}[*] To apply on server: sudo cp ${OUTPUT_FILE} /etc/logrotate.d/gigflow${NC}"
