#!/usr/bin/env bash
# Render a set of glitchify outputs so you can compare modes and intensities.
# Usage (from repo root):
#   ./examples/render_comparison_pack.sh ./examples/input/song.mp3
#   ./examples/render_comparison_pack.sh ./path/to/track.wav ./examples/output/my_compare
#
# Produces files named like: glitched_<stem>_lofi_i060.mp3 (see README in this folder).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GFI="$PROJECT_ROOT/gfi"

if [ "${1:-}" = "" ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  printf 'Usage: %s <input-audio> [output-dir]\n' "$(basename "$0")" >&2
  exit 1
fi

if [ ! -f "$1" ]; then
  printf 'Input file not found: %s\n' "$1" >&2
  exit 1
fi

INPUT="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUTPUT_DIR="${2:-$PROJECT_ROOT/examples/output/compare}"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"

run() {
  printf '→ %s\n' "$*"
  "$GFI" "$@"
}

# Three intensity steps (subtle → default → strong)
for intensity in 60 100 140; do
  tag="$(printf '%s' "$intensity" | awk '{ printf "%03d", $1 }')"
  run --mode lofi  --intensity "$intensity" --suffix "_lofi_i${tag}"  --output-dir "$OUTPUT_DIR" "$INPUT"
  run --mode loop  --intensity "$intensity" --suffix "_loop_i${tag}"  --output-dir "$OUTPUT_DIR" "$INPUT"
  run --mode wreck --intensity "$intensity" --suffix "_wreck_i${tag}" --output-dir "$OUTPUT_DIR" "$INPUT"
done

printf '\nDone. Outputs in: %s\n' "$OUTPUT_DIR"
ls -1 "$OUTPUT_DIR" | sort
