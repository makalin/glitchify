#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MODE="${1:-lofi}"
INPUT_DIR="${2:-$PROJECT_ROOT/examples/input}"
OUTPUT_DIR="${3:-$PROJECT_ROOT/examples/output}"

if [ "$#" -ge 1 ]; then
  shift
fi
if [ "$#" -ge 1 ]; then
  shift
fi
if [ "$#" -ge 1 ]; then
  shift
fi

if [ ! -d "$INPUT_DIR" ]; then
  printf 'Input directory not found: %s\n' "$INPUT_DIR" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

find "$INPUT_DIR" -type f \( \
  -iname '*.mp3' -o \
  -iname '*.wav' -o \
  -iname '*.flac' -o \
  -iname '*.m4a' -o \
  -iname '*.aiff' -o \
  -iname '*.ogg' \
\) | while IFS= read -r file; do
  "$PROJECT_ROOT/gfi" --mode "$MODE" --output-dir "$OUTPUT_DIR" "$@" "$file"
done
