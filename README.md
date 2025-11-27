# 👋 THIS REPOSITORY HAS MOVED! 👋

**This repository is no longer actively maintained on GitHub.**

Please update your bookmarks and remotes to the new home on Codeberg:

➡️ **[https://codeberg.org/alexeygumirov/pandoc-beamer-how-to](https://codeberg.org/alexeygumirov/pandoc-beamer-how-to)** ⬅️

Thank you for your understanding!

# make_deck - Pandoc Beamer Presentation Generator

A standalone tool for creating beautiful PDF presentations from Markdown using Pandoc and LaTeX beamer.

## Installation (macOS)

### Option 1: Homebrew (Recommended)

The easiest way to install `make_deck` on macOS:

```bash
# Add the tap and install make_deck (includes all dependencies)
brew tap hubrix/make_deck https://github.com/hubrix/make_deck
brew install make-deck

# Optional: Install enhanced fonts for better typography
brew install --cask font-hack-nerd-font
```

### Option 2: One-Shot Bootstrap

Install all dependencies automatically on macOS:

```bash
make bootstrap-macos
# or with options:
bash scripts/bootstrap-macos.sh --full-tex      # install mactex-no-gui instead of tectonic
bash scripts/bootstrap-macos.sh --no-fonts      # skip Nerd Fonts
bash scripts/bootstrap-macos.sh --no-imagemagick
```

### Option 3: Manual Installation

If you prefer manual installation:

```bash
# Install dependencies manually
brew install pandoc tectonic imagemagick

# Optional: Install fonts for enhanced typography
brew install --cask font-hack-nerd-font

# Download make_deck executable from this repository
```

## Quick Start

Once installed, creating presentations is simple:

```bash
# Basic usage
make_deck presentation.md presentation.pdf

# With enhanced styling (uses preamble.tex)
make_deck presentation.md presentation.pdf --preamble

# Get help
make_deck --help
```

### Using Make Targets

You can also use the provided Makefile:

```bash
make check      # verify pandoc and a TeX engine exist
make build      # generate presentation.pdf
make preamble   # generate presentation_nice_formatting.pdf with enhanced styling
make open       # open the generated PDF
```

## Example Markdown Structure

Create a `presentation.md` file with this structure:

```yaml
---
title: "My Presentation"
author: "Your Name"
institute: "Your Organization"
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: "Hack Nerd Font"
fontsize: 11pt
aspectratio: 169
date: "2024"
toc: true
---

# Introduction

This is the first slide.

## Key Points

- Point one
- Point two
- Point three

# Conclusion

Thank you for your attention!
```

## Installation (Other Platforms)

### Linux (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install pandoc imagemagick

# Install a TeX distribution
sudo apt-get install texlive-latex-recommended texlive-fonts-recommended
sudo apt-get install texlive-latex-extra texlive-fonts-extra texlive-xetex

# Download make_deck executable from this repository
```

### Manual Dependencies

If package managers aren't available:

1. Install [Pandoc](https://pandoc.org/installing.html)
2. Install a TeX engine:
   - [Tectonic](https://tectonic-typesetting.io/) (lightweight, recommended)
   - [MacTeX](https://www.tug.org/mactex/) (macOS)
   - [TeX Live](https://www.tug.org/texlive/) (cross-platform)
3. Download the `make_deck` executable

## Advanced Features

### Column Layouts

Use fenced divs for multi-column layouts:

```markdown
## Two Columns

::: columns

:::: column
Left content here.
::::

:::: column
Right content here.
::::

:::
```

### Custom Styling

The repository includes enhanced styling via `preamble.tex`:

- Custom color schemes
- Frame numbers
- Enhanced footer design
- Better code syntax highlighting

Use `--preamble` flag or `make preamble` to apply enhanced styling.

### Themes and Customization

Beamer offers many themes and color schemes:

- [Theme Matrix](https://hartwork.org/beamer-theme-matrix/)
- [Font Themes](https://deic-web.uab.cat/~iblanes/beamer_gallery/index_by_font.html)

## About This Project

This project builds on the excellent work from the original pandoc-beamer-how-to guide, providing:

- A standalone `make_deck` executable
- macOS-optimized installation via Homebrew
- Enhanced styling options
- Automated dependency management
- Cross-platform compatibility

### Technical Details

The tool uses:
- **Pandoc** for Markdown to LaTeX conversion
- **Tectonic** or **LuaLaTeX** for PDF generation
- **Beamer** for presentation formatting
- **Custom LaTeX templates** for enhanced styling

### Font Considerations

For best results with custom fonts:
- Install [Nerd Fonts](https://nerdfonts.com) for enhanced typography
- Use the `lualatex` engine for TrueType font support
- Specify fonts in the YAML frontmatter

## Examples

The repository includes example presentations:
- [Basic presentation](presentation.pdf) - default styling
- [Enhanced presentation](presentation_nice_formatting.pdf) - with preamble.tex

## Troubleshooting

### Common Issues

1. **"No TeX engine found"**: Install Tectonic or a TeX distribution
2. **Font not found**: Install the specified font or use system fonts
3. **Build fails**: Verify that all dependencies are properly installed

### Getting Help

- Run `make_deck --help` for usage information
- Run `make check` to verify dependencies
- See the detailed documentation below for advanced usage

---

## Detailed Documentation

### YAML Configuration

The YAML frontmatter supports extensive customization:

```yaml
title: "Presentation Title"
author: "Author Name"
institute: "Institution"
topic: "Subject Area"
theme: "Frankfurt"           # Beamer theme
colortheme: "beaver"         # Color scheme
fonttheme: "professionalfonts"
mainfont: "Hack Nerd Font"   # Custom font
fontsize: 10pt
urlcolor: red
linkstyle: bold
aspectratio: 169             # 16:9 aspect ratio
titlegraphic: img/logo.png   # Title slide graphic
logo: img/small-logo.png     # Corner logo
date: "March 2024"
lang: en-US
section-titles: false
toc: true                    # Table of contents
```

### Advanced Pandoc Options

The underlying Pandoc command supports many options:

- `--listings`: Enhanced code formatting
- `--toc`: Automatic table of contents
- `--slide-level 2`: H2 headers create new slides
- `--dpi=300`: High-resolution images
- Custom templates and filters

### Column Layout Examples

#### Equal Width Columns
```markdown
::: columns
:::: column
Left content
::::
:::: column  
Right content
::::
:::
```

#### Custom Width Columns
```markdown
::: columns
:::: {.column width=40%}
Narrow column
::::
:::: {.column width=60%}
Wide column
::::
:::
```

#### Three Columns
```markdown
::: columns
:::: column
Left
::::
:::: column
Center  
::::
:::: column
Right
::::
:::
```

### Images and Graphics

Format images for presentations:

```markdown
# With caption and sizing
![Caption text](image.png){width=80% height=60%}

# Centered image
![](image.png){.center width=50%}
```

### Code Blocks

Syntax highlighted code:

````markdown
```python
def hello_world():
    print("Hello, World!")
    return True
```
````

### Mathematical Expressions

LaTeX mathematical expressions are fully supported:

```markdown
Inline math: $E = mc^2$

Display math:
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```
