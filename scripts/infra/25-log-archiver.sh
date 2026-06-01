#!/usr/bin/env bash
# Description: Automated historical log compaction and cold-storage archiver.
set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_TARGET="runtime.log"
ARCHIVE_DIR="var/log/archive"

echo -e "${CYAN}[*] Spinning up automated cold-storage compression sequence...${NC}"

if [[ -f "$LOG_TARGET" ]]; then
    mkdir -p "$ARCHIVE_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_NAME="${ARCHIVE_DIR}/runtime_${TIMESTAMP}.log.gz"
    
    # Compress active stream into cold storage target
    gzip -c "$LOG_TARGET" > "$ARCHIVE_NAME"
    # Nullify active file to reset tracking allocations cleanly
    cat /dev/null > "$LOG_TARGET"
    
    echo -e "${GREEN}[V] Active telemetry compressed successfully to: ${ARCHIVE_NAME}${NC}"
else
    echo -e "[-] No active '${LOG_TARGET}' slice found to archive. Skipping loop."
fi
