.PHONY: validate test build

validate:
	@bash scripts/infra/01-env-validate.sh

test:
	@bash scripts/infra/02-test-runner.sh

build:
	@bash scripts/infra/03-docker-build.sh
