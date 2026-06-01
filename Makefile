# Description: Unified Infrastructure & Deployment Control Plane for Gigflow
.PHONY: audit logs-analyze archive-logs db-migrate db-seed proxy-test test-all

audit:
	@bash scripts/infra/23-audit-security.sh

logs-analyze:
	@bash scripts/infra/24-log-analyzer.sh

archive-logs:
	@bash scripts/infra/25-log-archiver.sh

db-migrate:
	@bash scripts/infra/26-db-migrate.sh

db-seed:
	@bash scripts/infra/27-db-seed.sh

proxy-test:
	@bash scripts/infra/28-proxy-check.sh

test-all:
	@bash scripts/infra/29-validate-pipeline.sh
