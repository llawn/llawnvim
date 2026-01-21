CHANGELOG_GEN := ./scripts/generate_changelog.sh

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
	@echo "--- Changelo Generation Complete ---"

release:
	@if [ -z "$(TAG)" ]; then \
		echo "Usage: make release TAG=<tag-name>"; \
		exit 1; \
	fi
	./scripts/release.sh $(TAG)

help:
	@echo "Available commands:"
	@echo "  build      - Build the documentation"
	@echo "  serve      - Serve documentation locally"
	@echo "  clean      - Clean built site"
	@echo "  changelog  - Generate changelog from git history"
	@echo "  release    - Create and push a new release tag (usage: make release TAG=<tag-name>)"
	@echo "  help       - Show this help message"
