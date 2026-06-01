#!/usr/bin/env bash
# Description: Generates a security-hardened SSH configuration block for the host system.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

OUTPUT_FILE="sshd_hardened.conf"

echo -e "${YELLOW}[*] Generating OS security hardening configurations...${NC}"

cat <<EOF > "$OUTPUT_FILE"
# Hardened SSH Configuration for GigFlow Production Host
# Target: /etc/ssh/sshd_config.d/gigflow.conf

# Enforce SSH Protocol 2
Protocol 2

# Disable root login over SSH completely
PermitRootLogin no

# Enforce secure authentication
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no

# Session management optimizations
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2

# Disable weak legacy features
X11Forwarding no
AllowTcpForwarding yes
EOF

echo -e "${GREEN}[*] Hardened SSH configuration written to ./${OUTPUT_FILE}${NC}"
echo -e "${GREEN}[*] To apply on server: sudo cp ${OUTPUT_FILE} /etc/ssh/sshd_config.d/gigflow.conf && sudo systemctl restart ssh${NC}"
