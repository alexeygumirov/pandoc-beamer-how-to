#!/bin/bash

# Test script to validate Homebrew tap functionality
set -e

echo "Testing Homebrew tap functionality..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This test is designed for macOS only"
    exit 1
fi

# Check if Formula directory and make-deck.rb exist
if [[ ! -f "Formula/make-deck.rb" ]]; then
    echo "Error: Formula/make-deck.rb not found"
    exit 1
fi

echo "✅ Formula file exists"

# Validate Ruby syntax
if ! ruby -c Formula/make-deck.rb > /dev/null; then
    echo "❌ Ruby syntax error in Formula/make-deck.rb"
    exit 1
fi

echo "✅ Ruby syntax is valid"

# Check if make_deck executable can be built
if ! make make_deck > /dev/null 2>&1; then
    echo "❌ Failed to build make_deck executable"
    exit 1
fi

echo "✅ make_deck executable builds successfully"

# Test make_deck functionality
if ! ./make_deck --help | grep -q "Usage: make_deck"; then
    echo "❌ make_deck --help doesn't work properly"
    exit 1
fi

echo "✅ make_deck --help works"

# Verify dependencies are listed correctly
if ! grep -q 'depends_on "pandoc"' Formula/make-deck.rb; then
    echo "❌ pandoc dependency not found in formula"
    exit 1
fi

echo "✅ Dependencies are correctly specified"

# Check for required formula fields
required_fields=("desc" "homepage" "url" "version" "sha256" "license")
for field in "${required_fields[@]}"; do
    if ! grep -q "$field" Formula/make-deck.rb; then
        echo "❌ Required field '$field' missing from formula"
        exit 1
    fi
done

echo "✅ All required formula fields present"

echo ""
echo "🎉 Homebrew tap validation successful!"
echo ""
echo "To use this tap:"
echo "  brew tap hubrix/make_deck https://github.com/hubrix/make_deck"
echo "  brew install make-deck"
echo ""
echo "Note: Make sure to install a TeX engine:"
echo "  brew install tectonic  # Recommended"
echo "  # OR"
echo "  brew install --cask mactex-no-gui  # Full TeX distribution"