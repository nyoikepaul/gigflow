#!/usr/bin/env bash
# Description: Telemetry script to monitor host system CPU, memory, and disk health.
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

CPU_THRESHOLD=80
MEM_THRESHOLD=85
DISK_THRESHOLD=90

echo -e "${GREEN}[*] Fetching system telemetry matrix...${NC}"

# 1. Check Disk Usage on Root Partition
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
echo -e "[-] Disk Usage: ${DISK_USAGE}%"
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo -e "${RED}[!] WARNING: Disk utilization has breached the safe ceiling!${NC}"
fi

# 2. Check Memory Utilization
MEM_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
echo -e "[-] Memory Usage: ${MEM_USAGE}%"
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo -e "${RED}[!] WARNING: Memory pool is heavily depleted!${NC}"
fi

# 3. Check CPU Load
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)
echo -e "[-] CPU Utilization: ${CPU_LOAD}%"
if [ "$CPU_LOAD" -gt "$CPU_THRESHOLD" ]; then
    echo -e "${YELLOW}[!] WARNING: High CPU load detected.${NC}"
fi

echo -e "${GREEN}[*] Telemetry snapshot complete.${NC}"
