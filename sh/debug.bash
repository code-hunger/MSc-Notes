#!/usr/bin/env bash
"""
Limits the layout iterations to 3,4,5, and for each choice compiles each page into its own svg.
Makes it possible to see which pages' layoutss do not converge in 5 steps.
"""
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 path/to/file.typ" >&2
  exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
  echo "Error: file not found: $file" >&2
  exit 1
fi

if ! command -v typst >/dev/null 2>&1; then
  echo "Error: 'typst' command not found in PATH." >&2
  exit 1
fi

base="$(basename "$file")"

for iter in 3 4 5; do
  (
    echo >&2 "Doing iter=$iter"
    echo '#import "@preview/layout-ltd:0.1.0": layout-limiter'
    printf '#show: layout-limiter.with(max-iterations: %s)\n' "$iter"
    cat "$file"
  ) | typst compile - "out/${base}.{p}.${iter}.svg"
done
