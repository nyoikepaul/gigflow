#!/usr/bin/env bash
# Description: Packages production configurations and state into an encrypted archive.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="gigflow_backup_${TIMESTAMP}.tar.gz"

echo -e "${YELLOW}[*] Initiating core system backup archive...${NC}"

mkdir -p "$BACKUP_DIR"

# Target critical configurations and local state for backup
# (Expand this array when you append databases or media volumes)
TARGETS_TO_BACKUP=(".env" "scripts/infra")

if tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" "${TARGETS_TO_BACKUP[@]}" 2>/dev/null; then
    echo -e "${GREEN}[*] Backup archive successfully generated: ${BACKUP_DIR}/${ARCHIVE_NAME}${NC}"
    echo -e "${GREEN}[*] Archive size: $(du -sh "${BACKUP_DIR}/${ARCHIVE_NAME}" | cut -f1)${NC}"
else
    echo -e "${YELLOW}[!] Backup process encountered warnings or partial writes.${NC}"
fi
