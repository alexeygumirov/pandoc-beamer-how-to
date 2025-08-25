#!/usr/bin/env bash

# make_deck - A truly standalone pandoc beamer presentation generator
# Usage: make_deck input.md output.pdf [--preamble]

set -e

# Configuration
SOURCE_FORMAT="markdown_strict+pipe_tables+backtick_code_blocks+auto_identifiers+strikeout+yaml_metadata_block+implicit_figures+all_symbols_escapable+link_attributes+smart+fenced_divs"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create embedded template files
create_templates() {
    local temp_dir="$1"
    
    # Create the default_mod.latex template
    cat > "$temp_dir/default_mod.latex" << 'TEMPLATE_EOF'
__DEFAULT_MOD_LATEX_CONTENT__
TEMPLATE_EOF

    # Create the preamble.tex file
    cat > "$temp_dir/preamble.tex" << 'PREAMBLE_EOF'
__PREAMBLE_TEX_CONTENT__
PREAMBLE_EOF
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: make_deck input.md output.pdf [--preamble]

A portable pandoc beamer presentation generator.

Arguments:
  input.md     Input Markdown file
  output.pdf   Output PDF file
  --preamble   Use enhanced styling with preamble.tex

Examples:
  make_deck presentation.md presentation.pdf
  make_deck slides.md slides.pdf --preamble

Requirements:
  - pandoc
  - One of: tectonic, lualatex, xelatex
EOF
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# Validate arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Error: Invalid number of arguments." >&2
    show_usage >&2
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
USE_PREAMBLE=false

if [ $# -eq 3 ]; then
    if [ "$3" = "--preamble" ]; then
        USE_PREAMBLE=true
    else
        echo "Error: Unknown option '$3'" >&2
        show_usage >&2
        exit 1
    fi
fi

# Validate input file
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found." >&2
    exit 1
fi

# Check for required dependencies
if ! command_exists pandoc; then
    echo "Error: pandoc is not installed or not in PATH." >&2
    echo "Install with: brew install pandoc (macOS) or see https://pandoc.org/installing.html" >&2
    exit 1
fi

# Choose a PDF engine
PDF_ENGINE=""
if command_exists tectonic; then
    PDF_ENGINE="tectonic"
elif command_exists lualatex; then
    PDF_ENGINE="lualatex"
elif command_exists xelatex; then
    PDF_ENGINE="xelatex"
else
    echo "Error: No TeX engine found (tectonic/lualatex/xelatex)." >&2
    echo "Install one of:" >&2
    echo "  - tectonic: brew install tectonic (recommended on macOS)" >&2
    echo "  - TeX distribution: brew install --cask mactex-no-gui" >&2
    exit 1
fi

echo "Using PDF engine: $PDF_ENGINE"

# Get current date
DATE_COVER=$(date "+%d %B %Y")

# Create temporary directory for templates
TEMP_DIR=$(mktemp -d)
trap "rm -rf '$TEMP_DIR'" EXIT

# Create embedded templates
create_templates "$TEMP_DIR"

# Build pandoc command using templates from temp directory
PANDOC_CMD=(
    pandoc
    -s
    --dpi=300
    --slide-level 2
    --toc
    --listings
    --shift-heading-level=0
    --template "$TEMP_DIR/default_mod.latex"
    --pdf-engine "$PDF_ENGINE"
    -f "$SOURCE_FORMAT"
    -M "date=$DATE_COVER"
    -V classoption:aspectratio=169
    --highlight-style=tango
    -t beamer
    "$INPUT_FILE"
    -o "$OUTPUT_FILE"
)

# Add preamble if requested
if [ "$USE_PREAMBLE" = true ]; then
    PANDOC_CMD+=(-H "$TEMP_DIR/preamble.tex")
fi

# Execute pandoc command
echo "Generating PDF: $OUTPUT_FILE"
"${PANDOC_CMD[@]}"

if [ $? -eq 0 ]; then
    echo "Successfully generated: $OUTPUT_FILE"
else
    echo "Error: Failed to generate PDF" >&2
    exit 1
fi