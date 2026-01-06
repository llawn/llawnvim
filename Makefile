.PHONY: build serve clean

build:
	mkdocs build

serve:
	mkdocs serve

clean:
	rm -rf site/

help:
	@echo "Available commands:"
	@echo "  build    - Build the documentation"
	@echo "  serve    - Serve documentation locally"
	@echo "  clean    - Clean built site"
