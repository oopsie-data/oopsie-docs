#!/usr/bin/env bash
# Link local visualizer media into Jekyll's _site without copying ~11GB.
# Run after a clean `jekyll build`/`jekyll serve` if /assets/visualizer 404s.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_ASSETS="$ROOT/_site/assets"
SRC="$ROOT/assets/visualizer"

if [[ ! -d "$SRC" ]]; then
  echo "Missing $SRC — run generate_visualizer_assets.py first (OUTPUT_ROOT points here)." >&2
  exit 1
fi

mkdir -p "$SITE_ASSETS"
ln -sfn ../../assets/visualizer "$SITE_ASSETS/visualizer"
echo "Linked $SITE_ASSETS/visualizer -> ../../assets/visualizer"
