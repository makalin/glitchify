#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Install it first:\n' >&2
  printf '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n' >&2
  exit 1
fi

brew install ffmpeg sox

printf 'Installed dependencies:\n'
command -v ffmpeg
command -v ffprobe
command -v sox
