# Glitchify

English | [Turkce](README.tr.md)

Glitchify is a command-line audio remixer for macOS that turns clean source audio into degraded, nostalgic, broken, and cinematic glitch textures.

Its practical CLI entrypoint is `gfi`, with `glitchify.sh` kept as a compatibility wrapper.

It is built around a stable `ffmpeg` + `sox` pipeline, but it now behaves like a real tool instead of a one-off script:

- short command name
- creator-facing modes
- user-controlled intensity
- repeatable randomization with seeds
- optional texture layering
- alternate audio formats
- simple static-video export for social posting
- batch processing and smoke-test scripts

## Latest Changes

- practical short CLI name: `gfi`
- `glitchify.sh` kept as a compatibility wrapper
- simplified sound modes: `lofi`, `loop`, `wreck`
- added micro tempo drift and needle-loop glitch behavior
- `loop` and `wreck` now include stronger skip-style effects
- smoke test updated to cover audio plus MP4 output paths

## Features

Glitchify applies a layered processing chain:

1. decode and normalize the source into a working WAV
2. degrade it by downsampling and narrowing the band
3. add cassette-style movement
4. apply micro tempo drift
5. add large atmospheric reverb and drive
6. optionally blend in a texture bed
7. inject needle-loop glitches and occasional reverse cuts
8. export audio and optional video deliverables

Available modes:

- `lofi`: musical drift with one clean loop
- `loop`: repeated needle loops and stronger movement
- `wreck`: harsher, more damaged, and less stable

Effect character:

- `lofi` is the safe default for actual songs
- `loop` leans into vinyl-skip / needle-loop behavior
- `wreck` combines loop glitches, drift, texture, and occasional reverse fragments

## Installation

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install dependencies

Either install manually:

```bash
brew install ffmpeg sox
```

Or use the helper:

```bash
chmod +x scripts/install-deps.sh
./scripts/install-deps.sh
```

### 3. Clone and prepare the project

```bash
git clone https://github.com/frangedev/glitchify.git
cd glitchify
chmod +x gfi glitchify.sh examples/batch_glitchify.sh scripts/install-deps.sh scripts/smoke-test.sh
```

## Quick Start

```bash
./gfi ./path/to/song.mp3
```

That writes a file beside the input, prefixed with `glitched_`.

## CLI Usage

```text
Usage: gfi [options] <input-audio>

Core options:
  -m, --mode <name>                 Mode: lofi, loop, wreck
  -o, --output <path>               Write audio to a custom path
      --output-dir <dir>            Directory for generated files
      --format <mp3|wav|flac|ogg|m4a>
      --suffix <text>               Add a suffix before the output extension
      --bitrate <value>             Audio bitrate for lossy formats
      --sample-rate <hz>            Output sample rate

Sound design:
      --intensity <1-200>           Scale the amount of degradation
      --glitch-length <seconds>     Override needle-loop slice length
      --glitch-repeat <count>       Override needle-loop repeat count
      --randomize                   Randomize the preset subtly
      --seed <number>               Seed for repeatable randomization
      --texture <path|random>       Mix a texture bed from file or textures folder
      --texture-level <db>          Texture level in dB
      --list-modes                  Print available modes

Video export:
      --video-image <path>          Render a static-image MP4 with the final audio
      --video-color <hex>           Render a solid-color MP4
      --video-output <path>         Custom output path for the MP4

Workflow:
  -k, --keep-temp                   Keep intermediate files
  -f, --force                       Overwrite existing output files
      --version                     Show version
  -h, --help                        Show help
```

## Examples

Basic:

```bash
./gfi song.mp3
```

More aggressive:

```bash
./gfi --mode wreck --intensity 150 song.wav
```

Repeatable randomized render:

```bash
./gfi --mode loop --randomize --seed 42 song.wav
```

Texture layer:

```bash
./gfi --texture random --texture-level -20 song.mp3
```

Ogg export:

```bash
./gfi --format ogg --bitrate 160k song.wav
```

Social-ready MP4:

```bash
./gfi --video-color '#081018' --output-dir ./exports song.wav
```

More runnable examples are in [examples/README.md](examples/README.md).

## Security Notes

I reviewed the current shell surface for obvious safety issues.

- the tool does not use `eval`
- external commands are invoked with quoted arguments
- temp work is created with `mktemp` and private permissions
- overwrite behavior is explicit and gated by `--force`
- `--video-color` is validated as a hex color before being passed to ffmpeg

Current limits:

- this is still a local CLI that executes `ffmpeg` and `sox` on files you point it at
- texture discovery uses `find` output and is intended for normal filesystem paths, not adversarial filenames with embedded newlines
- I could not run `shellcheck` here because it is not installed in this environment

## Project Layout

```text
.
├── gfi
├── glitchify.sh
├── examples
│   ├── README.md
│   ├── batch_glitchify.sh
│   └── input
├── scripts
│   ├── install-deps.sh
│   └── smoke-test.sh
├── textures
│   └── README.md
├── .gitignore
├── LICENSE
└── README.md
```

## Popularity-Oriented Product Direction

If you want this to spread, the tool needs to be predictable for creators and easy to share:

- short command users will actually type
- creator-facing modes with recognizable behavior
- seeded randomization so creators can reproduce a good render
- one-command MP4 export for Shorts, Reels, and TikTok workflows
- texture layering so outputs feel less generic
- smoke-test automation so releases are less likely to break

The next obvious steps after this version are:

- package it with a Homebrew tap
- add waveform or cover-art templates for richer videos
- publish a few free starter textures in `textures/`
- add preset demos in a `demo/` folder for social proof
- add CI that runs `scripts/smoke-test.sh`

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
