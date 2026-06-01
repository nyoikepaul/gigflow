#!/usr/bin/env bash
# Description: Builds and tags the production Docker image using Git hashes.
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

IMAGE_NAME="gigflow-app"

# Ensure we are in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}[!] Not inside a Git repository. Cannot generate tag.${NC}"
    exit 1
fi

# Grab the short hash of the latest commit
GIT_HASH=$(git rev-parse --short HEAD)
TAG="${IMAGE_NAME}:${GIT_HASH}"
LATEST="${IMAGE_NAME}:latest"

echo -e "${BLUE}[*] Building Docker image: ${TAG}...${NC}"

# Execute the build
if docker build -t "$TAG" -t "$LATEST" .; then
    echo -e "${GREEN}[*] Successfully built and tagged: ${TAG}${NC}"
    echo -e "${GREEN}[*] Latest tag updated.${NC}"
else
    echo -e "${RED}[!] Docker build failed.${NC}"
    exit 1
fi
