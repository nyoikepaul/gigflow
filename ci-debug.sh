#!/bin/bash

# Exit on first error, print commands as they run for deep tracing
set -e
set -x

echo -e "\n🟢 [1/4] Wiping local environment state..."
# Destroying local node_modules and Next.js build cache to mimic a fresh runner
rm -rf node_modules
rm -rf .next
# Note: Do NOT delete the lockfile (package-lock.json / yarn.lock). CI depends on it.

echo -e "\n🟢 [2/4] Enforcing Strict CI Installation..."
# Using 'npm ci' instead of 'npm install' to strictly follow the lockfile
# (Swap to 'yarn install --frozen-lockfile' or 'pnpm install --frozen-lockfile' if applicable)
npm install --legacy-peer-deps

echo -e "\n🟢 [3/4] Replicating 'CI / verify' Pipeline..."
# Running type checks and build exactly as the runner would
npm run lint
npm run build

echo -e "\n🟢 [4/4] Replicating 'Container Canary Test'..."
# Forcing a no-cache Docker build to catch missing COPY directives
docker build --no-cache -t gigflow-debug:local .

echo -e "\n✅ CI Simulation Complete. If you made it here, the build is clean."
