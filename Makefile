CHANGELOG_GEN := ./scripts/generate_changelog.sh

.PHONY: build serve clean changelog

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

help:
	@echo "Available commands:"
	@echo "  build      - Build the documentation"
	@echo "  serve      - Serve documentation locally"
	@echo "  clean      - Clean built site"
	@echo "  changelog  - Generate changelog from git history"
	@echo "  help       - Show this help message"
