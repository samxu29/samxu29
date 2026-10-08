# LaTeX tools for tex/cv.tex

Install the Arch packages, then the four user-tree packages. `texlive-fontsextra` is not required. `fontawesome5` is installed on its own below.

```bash
sudo pacman -S texlive-bin texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra
tlmgr init-usertree
tlmgr --usermode install fontawesome5 palatino courier helvetic
```

`texlive-latexextra` also installs `texlive-pictures`. Python packages for `pdf2png.py` are in `requirements.txt`:

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

## Pacman packages

| Package | Version installed | What cv.tex uses from it |
|---|---|---|
| texlive-bin | 2026.0-2.1 | `pdflatex` |
| texlive-basic | 2026.1-1 | TeX Live base files |
| texlive-latex | 2026.1-1 | `article`, `fontenc`, `inputenc`, `textcomp` |
| texlive-latexrecommended | 2026.1-1 | `geometry`, `amsmath`, `array`, `tabularx`, `microtype`, `booktabs`, `url`, `hyperref`, `color`, `palatino.sty` |
| texlive-pictures | 2026.1-1 | pulled in by `texlive-latexextra` |
| texlive-latexextra | 2026.1-1 | `enumitem`, `wrapfig`, `titlesec`, `makecell`, `pbox` |

## User-tree packages (`tlmgr --usermode`)

These live in `~/texmf`. The style or metrics are not in the pacman packages above.

| Package | Why cv.tex needs it |
|---|---|
| fontawesome5 | `\faPhone`, `\faEnvelope`, `\faLinkedin`, `\faGithub` |
| palatino | Palatino metrics (`pplr8t` and the bold, italic, and small-caps shapes). `palatino.sty` is already in `texlive-latexrecommended`. |
| courier | Courier Bold (`pcrb8t`) for `\url` inside `\textbf`. `palatino.sty` sets the typewriter font to Courier. |
| helvetic | Helvetica. `palatino.sty` sets the sans-serif font to Helvetica. |
| roboto | Roboto Slab, the resume roman font (`\usepackage[rm]{roboto}`) |
| lato | Lato, the resume sans font (`\usepackage[defaultsans]{lato}`) |

## Resume class

`altacv` is not in TeX Live. `asset/altacv.cls` is AltaCV v1.7.4 (30 Jul 2025), written by LianTze Lim (liantze@gmail.com). The file in this repo is taken from [https://github.com/liantze/AltaCV/blob/main/altacv.cls](https://github.com/liantze/AltaCV/blob/main/altacv.cls). It may be distributed and modified under the [LaTeX Project Public License](http://www.latex-project.org/lppl.txt), version 1.3 or later.

Contributions recorded in that file:

- [akreuzer](https://github.com/akreuzer) added the `ragged2e` option (5 Nov 2018)
- [stefanogermano](https://github.com/stefanogermano) fixed bad boxes and an undefined font shape (July 2018)
- [foohyfooh](https://github.com/foohyfooh) fixed blank spaces in `\cvevent` and a bad link in the README (June 2018)
- [logological](https://github.com/logological) removed a redundant `hyperref` load and typos (Apr 2021)

`tex/resume.tex` loads it with `\documentclass{../asset/altacv}`. The sample conditional `\ifxetexorluatex` is `\iftutex` in this version.

`\photoR{3cm}{../asset/shengkai}` uses `asset/shengkai.jpg`.
