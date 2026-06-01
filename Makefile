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
