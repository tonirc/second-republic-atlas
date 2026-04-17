#!/usr/bin/env bash
set -euo pipefail

# Render each language into an in-project temp folder to avoid
# Quarto's site_libs cleanup warning, then sync to deploy docs/.
for lang in en es ca; do
  quarto render "$lang" --output-dir "docs/$lang"
  rsync -a --delete "$lang/docs/$lang/" "docs/$lang/"
done

rm -rf en/docs es/docs ca/docs
