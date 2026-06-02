#!/usr/bin/env bash

# ==============================================================================
# GigFlow Schema Property Aligner
# Extracts the actual monetary field key from the Gig interface and patches the UI.
# ==============================================================================

set -euo pipefail

STORE_FILE="./store/useGigStore.ts"

echo -e "\033[0;36m[+] Extracting Gig type interface from storage tier...\033[0m"
echo "--------------------------------------------------"
# Display interface for debugging transparency
sed -n '/interface Gig/,/}/p; /type Gig/,/}/p' "$STORE_FILE" || grep -A 8 "Gig" "$STORE_FILE"
echo "--------------------------------------------------"

# Auto-detect standard financial property variations
FIELD_NAME=""
if grep -q "price" "$STORE_FILE"; then
    FIELD_NAME="price"
elif grep -q "amount" "$STORE_FILE"; then
    FIELD_NAME="amount"
elif grep -q "value" "$STORE_FILE"; then
    FIELD_NAME="value"
elif grep -q "cost" "$STORE_FILE"; then
    FIELD_NAME="cost"
fi

if [ -n "$FIELD_NAME" ]; then
    echo -e "\033[0;32m[+] Found matching store property token: '$FIELD_NAME'\033[0m"
    echo -e "\033[0;36m[+] Refactoring '.budget' keys to '.$FIELD_NAME' inside app/page.tsx...\033[0m"
    
    # Replace dot notation and sorting field type parameters
    sed -i "s/\.budget/\.$FIELD_NAME/g" app/page.tsx
    sed -i "s/'budget'/'$FIELD_NAME'/g" app/page.tsx
    sed -i "s/budget:/$FIELD_NAME:/g" app/page.tsx
    
    echo -e "\033[0;32m[+] Refactoring complete. Re-running production build compilation...\033[0m"
    echo "--------------------------------------------------"
    npm run build
else
    echo -e "\033[0;33m[!] Matcher fallback triggered: Could not auto-detect financial field signature keys.\033[0m"
    echo -e "\033[0;35m[*] Please inspect the printed interface tokens above and manually update line 26.\033[0m"
fi
