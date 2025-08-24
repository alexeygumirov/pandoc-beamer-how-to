SHELL := /bin/sh

.PHONY: help check build preamble open bootstrap-macos

help:
	@echo "Targets:"
	@echo "  check      - Verify dependencies (pandoc + TeX engine)"
	@echo "  build      - Generate presentation.pdf"
	@echo "  preamble   - Generate presentation_nice_formatting.pdf"
	@echo "  open       - Open generated PDF (macOS/Linux)"
	@echo "  bootstrap-macos - Install deps via Homebrew (pandoc, tectonic, etc.)"

check:
	@ok=1; \
	for c in pandoc; do \
		if ! command -v $$c >/dev/null 2>&1; then echo "Missing: $$c"; ok=0; fi; \
	done; \
	if command -v tectonic >/dev/null 2>&1; then \
		echo "Found TeX engine: tectonic"; \
	elif command -v lualatex >/dev/null 2>&1; then \
		echo "Found TeX engine: lualatex"; \
	elif command -v xelatex >/dev/null 2>&1; then \
		echo "Found TeX engine: xelatex"; \
	else \
		echo "Missing TeX engine (install 'tectonic' or a TeX distribution providing lualatex/xelatex)."; ok=0; \
	fi; \
	if [ $$ok -eq 1 ]; then echo "All required dependencies are present."; else echo "Some dependencies are missing."; exit 1; fi

build:
	./_pres-gen.sh

preamble:
	./_pres-gen.sh -preamble

open:
	@pdf=./presentation.pdf; \
	[ -f "$$pdf" ] || pdf=./presentation_nice_formatting.pdf; \
	if [ -f "$$pdf" ]; then \
		if command -v open >/dev/null 2>&1; then open "$$pdf"; \
		elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$$pdf"; \
		else echo "Open '$$pdf' manually."; fi; \
	else echo "No PDF found. Run 'make build' or 'make preamble' first."; exit 1; fi

bootstrap-macos:
	bash scripts/bootstrap-macos.sh
