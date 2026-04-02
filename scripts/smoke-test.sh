#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/glitchify-smoke.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Missing dependency: %s\n' "$1" >&2
    exit 1
  }
}

require_command ffmpeg
require_command ffprobe
require_command sox

mkdir -p "$TMP_DIR/textures" "$TMP_DIR/output"

sox -n -r 44100 -c 2 "$TMP_DIR/input.wav" synth 1.8 sine 220 sine 440
sox -n -r 44100 -c 2 "$TMP_DIR/textures/noise.wav" synth 1 brownnoise vol 0.15

"$PROJECT_ROOT/gfi" --mode lofi --suffix _lofi --output-dir "$TMP_DIR/output" "$TMP_DIR/input.wav"
"$PROJECT_ROOT/gfi" --mode loop --suffix _loop --randomize --seed 17 --output-dir "$TMP_DIR/output" "$TMP_DIR/input.wav"
"$PROJECT_ROOT/gfi" --mode wreck --suffix _wreck --texture "$TMP_DIR/textures/noise.wav" --video-color '#081018' --output-dir "$TMP_DIR/output" "$TMP_DIR/input.wav"

printf 'Smoke test outputs:\n'
find "$TMP_DIR/output" -maxdepth 1 -type f | sort
