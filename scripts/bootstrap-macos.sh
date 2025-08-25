#!/usr/bin/env bash
set -euo pipefail

# Bootstrap dependencies for macOS (Apple Silicon or Intel)
# - Installs: pandoc, tectonic (or mactex-no-gui with --full-tex), optional imagemagick, optional Nerd Font

FULL_TEX=0
INSTALL_FONTS=1
INSTALL_IMAGEMAGICK=1

while [ "$#" -gt 0 ]; do
  case "$1" in
    --full-tex)
      FULL_TEX=1
      shift
      ;;
    --no-fonts)
      INSTALL_FONTS=0
      shift
      ;;
    --no-imagemagick)
      INSTALL_IMAGEMAGICK=0
      shift
      ;;
    -h|--help)
      cat <<EOF
Usage: bash scripts/bootstrap-macos.sh [options]

Options:
  --full-tex         Install full TeX via mactex-no-gui (instead of tectonic)
  --no-fonts         Skip installing Nerd Font (Hack Nerd Font)
  --no-imagemagick   Skip installing ImageMagick
  -h, --help         Show this help and exit

Defaults:
  - pandoc and tectonic installed (unless --full-tex)
  - fonts and imagemagick installed by default
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install it first:" >&2
  echo "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
  exit 1
fi

echo "Using Homebrew at: $(command -v brew)"

ensure_formula() {
  local formula="$1"
  if brew list --formula "$formula" >/dev/null 2>&1; then
    echo "✓ $formula already installed"
  else
    echo "→ Installing $formula"
    brew install "$formula"
  fi
}

ensure_cask() {
  local cask="$1"
  if brew list --cask "$cask" >/dev/null 2>&1; then
    echo "✓ $cask already installed"
  else
    echo "→ Installing $cask"
    brew install --cask "$cask"
  fi
}

echo "Checking core tools..."
ensure_formula pandoc

if [ "$FULL_TEX" -eq 1 ]; then
  echo "Installing full TeX distribution (mactex-no-gui)"
  ensure_cask mactex-no-gui
else
  echo "Installing lightweight TeX engine (tectonic)"
  ensure_formula tectonic
fi

if [ "$INSTALL_IMAGEMAGICK" -eq 1 ]; then
  ensure_formula imagemagick
fi

if [ "$INSTALL_FONTS" -eq 1 ]; then
  echo "Ensuring font tap and Nerd Font installed..."
  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  ensure_cask font-hack-nerd-font
fi

echo "\nDependency summary:"
echo "- pandoc:         $(command -v pandoc || echo 'not found')"
if command -v tectonic >/dev/null 2>&1; then
  echo "- TeX engine:     tectonic ($(command -v tectonic))"
elif command -v lualatex >/dev/null 2>&1; then
  echo "- TeX engine:     lualatex ($(command -v lualatex))"
elif command -v xelatex >/dev/null 2>&1; then
  echo "- TeX engine:     xelatex ($(command -v xelatex))"
else
  echo "- TeX engine:     not found"
fi
if command -v convert >/dev/null 2>&1; then
  echo "- ImageMagick:    $(command -v convert)"
else
  echo "- ImageMagick:    not installed"
fi

BREW_PREFIX=$(brew --prefix 2>/dev/null || true)
if [ -n "$BREW_PREFIX" ]; then
  case ":$PATH:" in
    *:"$BREW_PREFIX/bin":*) : ;;
    *)
      echo "\nNote: Homebrew bin ($BREW_PREFIX/bin) is not on your PATH. Add this to your shell profile:"
      echo "  export PATH=\"$BREW_PREFIX/bin:\$PATH\""
      ;;
  esac
fi

echo "\nDone. You can now run:"
echo "  make check"
echo "  make build   # or: ./_pres-gen.sh"

