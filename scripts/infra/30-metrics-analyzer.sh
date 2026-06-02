#!/usr/bin/env bash

# ==============================================================================
# GigFlow Executive Financial Metrics Analyzer
# Calculates MRR, Win Rate, and Average Deal Size from project records.
# ==============================================================================

set -euo pipefail

DATA_FILE="data/projects.json"
BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Ensure data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo -e "${YELLOW}[!] Error: Data file $DATA_FILE not found.${RESET}"
    exit 1
fi

echo -e "${BOLD}${CYAN}==================================================${RESET}"
echo -e "${BOLD}${CYAN}        GIGFLOW EXECUTIVE METRICS ENGINE         ${RESET}"
echo -e "${BOLD}${CYAN}==================================================${RESET}"

# 1. Primary Metrics Extraction via jq
TOTAL_ENGAGEMENTS=$(jq '. | length' "$DATA_FILE")
TOTAL_REVENUE=$(jq '[.[].budget] | add' "$DATA_FILE")
ACTIVE_CLIENTS=$(jq '[.[] | select(.status=="ACTIVE") .client] | unique | length' "$DATA_FILE")
COMPLETED_PROJECTS=$(jq '[.[] | select(.status=="COMPLETED")] | length' "$DATA_FILE")

# 2. Advanced Metrics Computation via awk
MRR=$(jq '[.[] | select(.status=="ACTIVE") .budget] | add' "$DATA_FILE" | sed 's/null/0/')

AVG_DEAL_SIZE=$(awk -v rev="$TOTAL_REVENUE" -v eng="$TOTAL_ENGAGEMENTS" '
    BEGIN { if (eng > 0) printf "%.2f", rev / eng; else printf "0.00" }
')

WIN_RATE=$(awk -v comp="$COMPLETED_PROJECTS" -v total="$TOTAL_ENGAGEMENTS" '
    BEGIN { if (total > 0) printf "%.1f", (comp / total) * 100; else printf "0.0" }
')

# 3. Render Output Dashboard
echo -e "${BOLD}Core Engine Pipeline:${RESET}"
echo -e "  Total Engagements   : ${BLUE}$TOTAL_ENGAGEMENTS${RESET}"
echo -e "  Active Clients      : ${BLUE}$ACTIVE_CLIENTS${RESET}"
echo -e "  Total Pipeline Value: ${GREEN}\$$TOTAL_REVENUE${RESET}"
echo -e "--------------------------------------------------"
echo -e "${BOLD}Advanced Financial Metrics:${RESET}"
echo -e "  Monthly Recurring (MRR) : ${GREEN}\$$MRR${RESET}  (From Active Contracts)"
echo -e "  Average Deal Size       : ${GREEN}\$$AVG_DEAL_SIZE${RESET}"
echo -e "  Pipeline Win Rate       : ${YELLOW}$WIN_RATE%${RESET}   ($COMPLETED_PROJECTS/$TOTAL_ENGAGEMENTS Completed)"
echo -e "${BOLD}${CYAN}==================================================${RESET}"
