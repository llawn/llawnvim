CHANGELOG_GEN := ./scripts/generate_changelog.sh
RELEASE_SCRIPT := ./scripts/release.sh

.PHONY: help build serve clean changelog release lint all

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' |  sed -e 's/^/ /'

## build: Build the documentation
build:
	mkdocs build

## serve: Serve documentation locally
serve:
	mkdocs serve

## clean: Clean built site
clean:
	rm -rf site/

## lint: Run selene
lint:
	selene .

## changelog: Generate changelog from git history
changelog:
	@echo "--- Starting Changelog Generation ---"
	@bash $(CHANGELOG_GEN)
	@echo "--- Changelog Generation Complete ---"

## release: Create and push a new release tag (make release TAG=<tag-name>)
release:
	@if [ -z "$(TAG)" ]; then \
		echo "Usage: make release TAG=<tag-name>"; \
		exit 1; \
	fi
	@bash $(RELEASE_SCRIPT) $(TAG)

## all: Run lint
all: lint
