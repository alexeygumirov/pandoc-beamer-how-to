#!/bin/bash

DATE_COVER=$(date "+%d %B %Y")
SOURCE_FORMAT="markdown_github+yaml_metadata_block+implicit_figures+all_symbols_escapable+link_attributes"

pandoc -s -S --dpi=300 --slide-level 2 --toc --template default --listings -f "$SOURCE_FORMAT" -M date="$DATE_COVER" -V classoption:aspectratio=169 -V lang=en-US -t beamer header.yaml presentation.md -o presentation.pdf
