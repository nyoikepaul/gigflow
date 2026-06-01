#!/usr/bin/env bash
# Description: Generates Fail2Ban configuration to protect SSH and Nginx from brute-force attacks.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

OUTPUT_FILE="jail.local"

echo -e "${GREEN}[*] Generating Fail2Ban jail configuration...${NC}"

cat <<EOF > "$OUTPUT_FILE"
# Fail2Ban Custom Jail Configuration for GigFlow
[DEFAULT]
bantime  = 1h
findtime  = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3

[nginx-http-auth]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/error.log

[nginx-botsearch]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/access.log
maxretry = 2
EOF

echo -e "${GREEN}[*] Fail2Ban configuration generated at ./${OUTPUT_FILE}${NC}"
echo -e "${GREEN}[*] To apply on server: sudo cp ${OUTPUT_FILE} /etc/fail2ban/jail.local && sudo systemctl restart fail2ban${NC}"
