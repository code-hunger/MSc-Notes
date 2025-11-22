#!/usr/bin/env bash
set -euo pipefail
"""
Finds the first page output from debug.bash which differs across iterations 3,4,5.
"""

# Usage: ./compare-pages.sh path/to/file.typ
if [ $# -ne 1 ]; then
  echo "Usage: $0 path/to/file.typ" >&2
  exit 2
fi

file="$1"
if [ ! -f "$file" ]; then
  echo "Error: file not found: $file" >&2
  exit 2
fi

dir="$(cd "$(dirname "$file")" && pwd)"
base="$(basename "$file")"

# Number of pages to check
N=15

cd "$dir"

for ((p = 1; p <= N; p++)); do
  f3="out/${base}.${p}.3.svg"
  f4="out/${base}.${p}.4.svg"
  f5="out/${base}.${p}.5.svg"

  # Ensure all files exist for this page
  for f in "$f3" "$f4" "$f5"; do
    if [ ! -f "$f" ]; then
      echo "Error: missing file: $f" >&2
      exit 2
    fi
  done

  # If all three are identical, continue
  if cmp -s "$f3" "$f4" && cmp -s "$f3" "$f5"; then
    continue
  fi

  echo "Difference detected on page $p."

  if ! cmp -s "$f3" "$f4"; then
    echo "--- diff (iter 3 vs 4) for page $p ---"
    diff -u "$f3" "$f4" || true
  elif ! cmp -s "$f3" "$f5"; then
    echo "--- diff (iter 3 vs 5) for page $p ---"
    diff -u "$f3" "$f5" || true
  else
    echo "--- diff (iter 4 vs 5) for page $p ---"
    diff -u "$f4" "$f5" || true
  fi

  # Stop at the first differing page
  exit 1
done

echo "All pages identical across iterations 3, 4, 5 (checked 1..$N)."
