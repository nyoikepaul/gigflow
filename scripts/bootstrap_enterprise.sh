#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Hardening GigFlow..."

mkdir -p \
.github/workflows \
.github/ISSUE_TEMPLATE \
docs \
tests/unit \
tests/integration \
e2e \
monitoring \
infra

touch \
SECURITY.md \
CONTRIBUTING.md \
CODEOWNERS \
docs/architecture.md \
docs/deployment.md \
docs/roadmap.md \
docs/api.md

cat > .github/PULL_REQUEST_TEMPLATE.md <<'EOF'
## Summary

Describe your changes.

## Checklist

- [ ] Tests added
- [ ] Documentation updated
- [ ] Lint passes
- [ ] Type checks pass
EOF

cat > .github/ISSUE_TEMPLATE/bug.yml <<'EOF'
name: Bug Report
description: Report a bug
title: "[BUG] "
labels:
  - bug
body:
  - type: textarea
    id: bug
    attributes:
      label: Description
EOF

cat > .github/ISSUE_TEMPLATE/feature.yml <<'EOF'
name: Feature Request
description: Suggest a feature
title: "[FEATURE] "
labels:
  - enhancement
body:
  - type: textarea
    id: feature
    attributes:
      label: Proposal
EOF

cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
  pull_request:

jobs:
  verify:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 22

      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm run build
EOF

cat > .github/workflows/codeql.yml <<'EOF'
name: CodeQL

on:
  push:
  pull_request:

jobs:
  analyze:
    runs-on: ubuntu-latest

    permissions:
      actions: read
      contents: read
      security-events: write

    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript

      - uses: github/codeql-action/analyze@v3
EOF

cat > .github/dependabot.yml <<'EOF'
version: 2

updates:
  - package-ecosystem: npm
    directory: "/"
    schedule:
      interval: weekly
EOF

echo "✅ GigFlow enterprise scaffolding complete."
