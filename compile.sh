#!/usr/bin/env bash
# Compile tex/cv.tex and tex/resume.tex with pdfLaTeX, render each page
# into img/ via pdf2png.py, and delete year-stamped PDFs and PNGs
# (for example shengkaixu_2024cv.pdf).
#
# Usage, from anywhere:
#   ./compile.sh
#
# Outputs:
#   shengkaixu_cv.pdf, shengkaixu_resume.pdf
#   img/shengkaixu_cv.pdf_<page>.png, img/shengkaixu_resume.pdf_<page>.png

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT
cd "$ROOT"
PYTHON="$ROOT/.venv/bin/python"
if [[ ! -x "$PYTHON" ]]; then
  echo "error: $PYTHON is missing; create it with: python3 -m venv .venv && .venv/bin/pip install pymupdf pillow" >&2
  exit 1
fi

compile_tex() {
  local src="$1"
  local job="$2"
  local tex="tex/${src}.tex"
  local build

  if [[ ! -s "$tex" ]]; then
    echo "error: $tex is missing or empty" >&2
    exit 1
  fi

  build="$(mktemp -d)"
  if command -v latexmk >/dev/null 2>&1; then
    (
      cd tex
      latexmk -pdf -interaction=nonstopmode -halt-on-error \
        -output-directory="$build" -jobname="$job" "${src}.tex"
    )
  else
    (
      cd tex
      pdflatex -interaction=nonstopmode -halt-on-error \
        -output-directory="$build" -jobname="$job" "${src}.tex"
      pdflatex -interaction=nonstopmode -halt-on-error \
        -output-directory="$build" -jobname="$job" "${src}.tex"
    )
  fi

  cp "$build/${job}.pdf" "${job}.pdf"
  rm -rf "$build"

  rm -f img/"${job}.pdf"_*.png
  "$PYTHON" pdf2png.py "${job}.pdf" img
}

remove_year_stamped() {
  "$PYTHON" - <<'PY'
import os
import re
from pathlib import Path

root = Path(os.environ["ROOT"])
year = re.compile(r"(19|20)\d{2}")
removed = []
for folder, suffix in ((root, ".pdf"), (root / "img", ".png")):
    for path in folder.glob(f"*{suffix}"):
        if year.search(path.name):
            path.unlink()
            removed.append(path.relative_to(root).as_posix())
for name in removed:
    print(f"removed {name}")
PY
}

mkdir -p img
compile_tex cv shengkaixu_cv
compile_tex resume shengkaixu_resume
remove_year_stamped
echo "wrote shengkaixu_cv.pdf, shengkaixu_resume.pdf, and img previews"
