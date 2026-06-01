.PHONY: validate test build

validate:
	@bash scripts/infra/01-env-validate.sh

test:
	@bash scripts/infra/02-test-runner.sh

build:
	@bash scripts/infra/03-docker-build.sh

.PHONY: harden firewall watchdog

harden:
	@bash scripts/infra/16-harden-os.sh

firewall:
	@bash scripts/infra/08-ufw-setup.sh

watchdog:
	@bash scripts/infra/21-system-watchdog.sh

.PHONY: clean rotate-logs backup

clean:
	@bash scripts/infra/04-docker-clean.sh
	@bash scripts/infra/05-clean-cache.sh

rotate-logs:
	@bash scripts/infra/17-logrotate-setup.sh

backup:
	@bash scripts/infra/18-backup-engine.sh

.PHONY: up down logs

up:
	@docker compose up -d --build

down:
	@docker compose down

logs:
	@docker compose logs -f --tail=100

.PHONY: audit

audit:
	@bash scripts/infra/23-audit-security.sh

.PHONY: logs-analyze

logs-analyze:
	@bash scripts/infra/24-log-analyzer.sh

.PHONY: archive-logs

archive-logs:
	@bash scripts/infra/25-log-archiver.sh
