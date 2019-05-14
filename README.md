# Making presentations with Pandoc beamer

This is a short guide about how I make PDF slides using **beamer** format output from the **pandoc**.

I use default template and one of the pre-defined themes, color themes and font themes.

## How-to for docs preparation

### Tools

- **pandoc**

	- template: I use default template.

	> Matrix of beamer themes: [https://hartwork.org/beamer-theme-matrix/](https://hartwork.org/beamer-theme-matrix/)

	> Font themes: [http://www.deic.uab.es/~iblanes/beamer_gallery/index_by_font.html](http://www.deic.uab.es/~iblanes/beamer_gallery/index_by_font.html)

- **texlive**
- **convert**

    - converts and formats images.
    - it is used here for the change of DPI of the images and convert to PNG.
    - **convert** is the utility which is part of the **ImageMagick** package.

I did not install **convert** tool, it seems like it is installed by default in Ubuntu or comes with **texlive**.
To avoid possible issues with **pdflatex** engine I did full installation of **texlive** packet.

In Debian family (with **apt**):

```sh
sudo apt-get update
sudo apt-get install pandoc
sudo apt-get install imagemagick
```

I use following `texlive` packages:

```sh
sudo apt-get install texlive-latex-recommended
sudo apt-get install texlive-fonts-recommended
sudo apt-get install texlive-latex-extra
sudo apt-get install texlive-fonts-extra
sudo apt-get install texlive-xetex
```

Extra LaTeX packages are needed for **eisvogel** template to work. I also install XeTeX because if you have text with some special symbols, XeTeX can process it properly.

### Instructions and commands

#### YAML Block for LaTex template

This YAML block in the beginning of the MarkDown file defines parameters used by the Pandoc engine and relevant LaTex template parameters. This particular example below instructs Pandoc to produce PDF slides file with particular theme, color theme, etc.

```yaml
title: "My wonderful presentation"
author: "Alexey Gumirov"
topic: "Pandoc how-to"
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
date:
toc: true
```

This YAML block is inserted in the beginning of the markdown file.

#### Images preparation

The same way as in [my pandoc for PDF project](https://github.com/alexeygumirov/pandoc-for-pdf-how-to#images-preparation)

#### Pandoc command

```sh
#!/bin/bash

DATE_COVER=$(date "+%d %B %Y")
SOURCE_FORMAT="markdown_github+yaml_metadata_block\
	+implicit_figures+all_symbols_escapable+link_attributes"

pandoc -s -S --dpi=300 --slide-level 2 --toc --listings \
	--base-header-level=1 --template default -f "$SOURCE_FORMAT" \
	-M date="$DATE_COVER" -V classoption:aspectratio=169 \
	-V lang=en-US -t beamer presentation.md -o presentation.pdf
```

Options of the **pandoc** command mean following:

- `-s`: Standalone document.
- `-S`: `--smart`

    - Produce  typographically  correct  output,  converting  straight  quotes  to  curly  quotes, --- to em-dashes, -- to en-dashes, and ... to   ellipses.  Nonbreaking spaces are inserted after certain abbreviations, such as “Mr.” (Note: This option is  selected  automatically  when   the output format is latex or context, unless `--no-tex-ligatures` is used.  It has no effect for latex input.)
    > - In newer versions of **pandoc** this switch was removed and you shall use `+smart` extension in the `-f` option.

- `-f FORMAT` or `-r FORMAT`:

    - Specify input format. `FORMAT` can be `native` (native Haskell), `json` (JSON version of native AST), `markdown` (pandoc's extended Markdown), `markdown_strict`(original  unextended  Markdown),  `markdown_phpextra` (PHP Markdown Extra), `markdown_github` (GitHub-Flavored Markdown), `commonmark` (CommonMark Markdown), `textile` (Textile), `rst` (reStructuredText), `html` (HTML), `docbook` (DocBook), `t2t` (txt2tags), `docx` (docx), `odt` (ODT), `epub` (EPUB), `opml` (OPML), `org` (Emacs Org mode), `mediawiki` (MediaWiki markup), `twiki` (TWiki markup), `haddock` (Haddock markup), or `latex` (LaTeX).  If `+lhs` is appended to `markdown`, `rst`, `latex`, or `html`, the input will be treated as literate Haskell source. Markdown syntax extensions can be individually enabled or disabled by appending `+EXTENSION` or `-EXTENSION` to the format name.  So, for example, `markdown_strict+footnotes+definition_lists` is strict Markdown with footnotes and definition lists enabled, and `markdown-pipe_tables+hard_line_breaks`  is  pandoc's  Markdown  without pipe tables and with hard line breaks.
	- `implicit_figures`: An image with nonempty alt text, occurring by itself in a paragraph, will be rendered as a figure with a caption. The image’s alt text will be used as the caption. This extension is very useful when you need to autogenerate captions for figures in the markdown reference format like: ``` ![This is the caption](/url/of/image.png) ```
	- `all_symbols_escapable`: Except inside a code block or inline code, any punctuation or space character preceded by a backslash will be treated literally, even if it would normally indicate formatting.
	- `link_attributes`: Allows to add addional attributes to links (to images and refernce links). For pictures we can define width and height.

If `-S` is not working then option `-f` shall be used with `+smart` extension. E.g. for this particular document the option with parameters will look like this: `-f markdown_github+yaml_metadata_block+implicit_figures+tables_captions+smart+footnotes`.

- `--toc`: `--table-of-contents`

    - Include an automatically generated table of contents (or, in the case of latex, context, docx, and rst, an instruction to create  one)  in the output document.  This option has no effect on man, docbook, docbook5, slidy, slideous, s5, or odt output.

- `--dpi`:

    - Specify the dpi (dots per inch) value for conversion from pixels to inch/centimeters and vice versa.  The **default** is **96dpi**.  Technically, the correct term would be ppi (pixels per inch).

- `--base-header-level=N`: Specify the base level for heading (default is to 1).

- `--slide-level N`

	- Specifies that headings with the specified level create slides (for beamer, s5, slidy, slideous, dzslides). Headings above this level in the hierarchy are used to divide the slide show into sections; headings below this level create subheads within a slide. Note that content that is not contained under slide-level headings will not appear in the slide show. The default is to set the slide level based on the contents of the document.

- `-V KEY[=VAL]`: `--variable=KEY[:VAL]`

    - Set the template variable KEY to the value VAL when rendering the document in standalone mode.  This is generally  only  useful  when  the `--template`  option  is used to specify a custom template, since pandoc automatically sets the variables used in the default templates. If no `VAL` is specified, the key will be given the value true.
    - `lang`: one of the `KEY` parameters of `-V` which defines default document language.
	- `classoption:aspectratio=169`: produces presentation with 16:9 aspect ratio.

Additional useful options of the **pandoc** command are:

- `--listings`: It creates nice presentation of the raw code (like shell code or programming code).
- `--number-section`: Automatically creates enumerated headers. 
- `--default-image-extension`: If you want Pandoc to insert only one type of images, e.g. PNG, then you shall add `--default-image-extension png` in the command line.

## Examples

With this Markdown file I produce [this (presentation.pdf)](presentation.pdf).

```
---
title: "My wonderful presentation"
author: "Alexey Gumirov"
topic: "Pandoc how-to"
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
date:
toc: true
---

# General information
## Themes, fonts, etc.

- I use default **pandoc** themes.
- This presentation is made with **Frankfurt** theme and **beaver** color theme.
- I like **professionalfonts** font scheme. 

> Matrix of beamer themes: [https://hartwork.org/beamer-theme-matrix/](https://hartwork.org/beamer-theme-matrix/)

> Font themes: [http://www.deic.uab.es/~iblanes/beamer_gallery/index_by_font.html](http://www.deic.uab.es/~iblanes/beamer_gallery/index_by_font.html)

# Formatting
## Text formatting

Normal text.
*Italic text* and **bold text**.
~~Strike out~~ is supported. Is 'text' supported as well?

## Notes

> This is a note.

> > Nested note.

> And it continues.

## Blocks

### This is a block A

- Line A
- Line B

### 

New block without header.

### This is a block B.

- Line C
- Line D

## Listings

By some reasons, listings do not work in the default beamer template. Therefore it is better to put them in the blocks.

###
```
#!/bin/bash
echo "Hello world!"
echo "line"
```

## Table

**Item** | **Description** | **Q-ty**
:--------|-----------------:|:---:
Item A | Item A description | 2
Item B | Item B description | 5
Item C | N/A | 100

## Single picture 

This is how we insert picture. Caption is produced automatically from the alt text.

```
![Aleph 0](img/aleph0.png) 
```

![Aleph 0](img/aleph0.png) 

## Two or more pictures in a raw

Here are two pictures in the raw. We can also change two pictures size (height or width).

###
```
![Aleph 0](img/aleph0.png){height=10%}\ 
		![Aleph 0](img/aleph0.png)
```

![Aleph 0](img/aleph0.png){ height=10% }\ ![Aleph 0](img/aleph0.png){ height=100% }

## Lists

1. Idea 1
2. Idea 2
	- genius idea A
	- more genius 2
3. Conclusion
```
