#!/usr/bin/env bash

# ==============================================================================
# GigFlow Zustand Type Aligner
# Detects actual state shapes and applies clean destructuring aliases to the UI.
# ==============================================================================

set -euo pipefail

# 1. Locate the Zustand store definition file
STORE_FILE=$(find . -name "useGigStore.ts" -o -name "useGigStore.tsx" | head -n 1)

if [ -z "$STORE_FILE" ]; then
    echo -e "\033[0;31m[!] Error: Could not find useGigStore file in the directory structure.\033[0m"
    exit 1
fi

echo -e "\033[0;36m[+] Inspecting store schemas inside: $STORE_FILE\033[0m"

# 2. Determine state array signature
if grep -q "gigs" "$STORE_FILE"; then
    ARRAY_SIG="gigs"
else
    ARRAY_SIG="projects"
fi

# 3. Determine deletion routine signature
if grep -q "deleteGig" "$STORE_FILE"; then
    DELETE_SIG="deleteGig"
elif grep -q "removeGig" "$STORE_FILE"; then
    DELETE_SIG="removeGig"
else
    DELETE_SIG="deleteProject"
fi

echo -e "\033[0;32m[+] Detected State Array  : '$ARRAY_SIG'\033[0m"
echo -e "\033[0;32m[+] Detected Delete Routine: '$DELETE_SIG'\033[0m"

# 4. Construct precise destructuring override line
if [ "$ARRAY_SIG" = "gigs" ]; then
    if [ "$DELETE_SIG" = "deleteGig" ]; then
        BINDING="const { gigs: projects, deleteGig: deleteProject } = useGigStore();"
    elif [ "$DELETE_SIG" = "removeGig" ]; then
        BINDING="const { gigs: projects, removeGig: deleteProject } = useGigStore();"
    else
        BINDING="const { gigs: projects, deleteProject } = useGigStore();"
    fi
else
    if [ "$DELETE_SIG" = "deleteGig" ]; then
        BINDING="const { projects, deleteGig: deleteProject } = useGigStore();"
    elif [ "$DELETE_SIG" = "removeGig" ]; then
        BINDING="const { projects, removeGig: deleteProject } = useGigStore();"
    else
        BINDING="const { projects, deleteProject } = useGigStore();"
    fi
fi

# 5. Swap out line 10 safely without editing any secondary presentation markup
TARGET_PAGE="app/page.tsx"
sed -i "s|const { projects, deleteProject } = useGigStore();|$BINDING|g" "$TARGET_PAGE"

echo -e "\033[0;32m[+] Line 10 inside $TARGET_PAGE has been successfully re-aligned!\033[0m"
echo -e "\033[0;36m[+] Triggering compilation verification hook...\033[0m"
echo -e "--------------------------------------------------"

npm run build
