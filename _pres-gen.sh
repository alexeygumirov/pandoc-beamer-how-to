#!/usr/bin/env sh

DATE_COVER=$(date "+%d %B %Y")

SOURCE_FORMAT="markdown_strict\
+pipe_tables\
+backtick_code_blocks\
+auto_identifiers\
+strikeout\
+yaml_metadata_block\
+implicit_figures\
+all_symbols_escapable\
+link_attributes\
+smart\
+fenced_divs"

DATA_DIR="pandoc"

# Choose a PDF engine that is available on this system.
# Preference order: tectonic (self-contained), lualatex, xelatex.
if command -v tectonic >/dev/null 2>&1; then
    PDF_ENGINE="tectonic"
elif command -v lualatex >/dev/null 2>&1; then
    PDF_ENGINE="lualatex"
elif command -v xelatex >/dev/null 2>&1; then
    PDF_ENGINE="xelatex"
else
    echo "Error: No TeX engine found (tectonic/lualatex/xelatex)." >&2
    echo "Install one of: 'brew install tectonic' (recommended on macOS), or a TeX distribution providing lualatex/xelatex." >&2
    exit 1
fi

# Ensure pandoc exists
if ! command -v pandoc >/dev/null 2>&1; then
    echo "Error: pandoc is not installed or not in PATH." >&2
    echo "Install with Homebrew: 'brew install pandoc' or see https://pandoc.org/installing.html" >&2
    exit 1
fi

case "$1" in
    "-preamble")
        pandoc -s --dpi=300 --slide-level 2 --toc --listings --shift-heading-level=0 --data-dir="${DATA_DIR}" --template default_mod.latex -H pandoc/templates/preamble.tex --pdf-engine "${PDF_ENGINE}" -f "$SOURCE_FORMAT" -M date="$DATE_COVER" -V classoption:aspectratio=169 --highlight-style=tango -t beamer presentation.md -o presentation_nice_formatting.pdf
        ;;
    *)
        pandoc -s --dpi=300 --slide-level 2 --toc --listings --shift-heading-level=0 --data-dir="${DATA_DIR}" --template default_mod.latex --pdf-engine "${PDF_ENGINE}" -f "$SOURCE_FORMAT" -M date="$DATE_COVER" -V classoption:aspectratio=169 --highlight-style=tango -t beamer presentation.md -o presentation.pdf
        ;;
esac
