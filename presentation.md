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
