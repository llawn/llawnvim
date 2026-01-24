CHANGELOG_GEN := ./scripts/generate_changelog.sh
RELEASE_SCRIPT := ./scripts/release.sh

.PHONY: build serve clean changelog release

build:
	mkdocs build

serve:
	mkdocs serve

clean:
	rm -rf site/

changelog:
	@echo "--- Starting Changelog Generation ---"
	@bash $(CHANGELOG_GEN)
	@echo "--- Changelog Generation Complete ---"

release:
	@if [ -z "$(TAG)" ]; then \
		echo "Usage: make release TAG=<tag-name>"; \
		exit 1; \
	fi
	@bash $(RELEASE_SCRIPT) $(TAG)

help:
	@echo "  build      - Build the documentation"
	@echo "  serve      - Serve documentation locally"
	@echo "  clean      - Clean built site"
	@echo "  changelog  - Generate changelog from git history"
	@echo "  release    - Create and push a new release tag (usage: make release TAG=<tag-name>)"
