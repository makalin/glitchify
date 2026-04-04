# Examples

Run these commands from the **project root** (the directory that contains `gfi`).

Replace `./examples/input/song.mp3` with any supported file (`.wav`, `.flac`, `.m4a`, …). Put test files in `examples/input/` or pass an absolute path.

---

## Modes: `lofi`, `loop`, `wreck`

| Mode | What it sounds like | Good for |
|------|---------------------|----------|
| **lofi** | Softer degradation, lighter wow/flutter, **one** needle-loop style glitch | Songs you still want to recognize; safest default |
| **loop** | Stronger vinyl motion, **more** needle loops and skip-like behavior | Loops, beats, obvious “broken record” character |
| **wreck** | Harsher band/drive, **reverse** fragments, more unstable, heavier damage | Sound design, textures, “destroyed” aesthetics |

List the built-in blurbs:

```bash
./gfi --list-modes
```

---

## Intensity: `--intensity` (1–200)

Default is **100**. It scales how hard the chain pushes degradation, motion, reverb/drive, glitches, and (in **wreck**) reverse cuts.

| Rough range | Role |
|-------------|------|
| **60–80** | Gentler; more of the original comes through |
| **100** | Default balance |
| **120–160** | Heavier; more noise, smear, and glitch density |
| **170–200** | Extreme; use when you want maximum breakup |

---

## Compare the three modes (same file, same intensity)

Same input, different `--mode`. Using `--suffix` keeps filenames distinct; `--output-dir` puts them in one folder for A/B listening.

```bash
mkdir -p ./examples/output/compare_modes

./gfi --mode lofi  --intensity 100 --suffix _A_lofi  --output-dir ./examples/output/compare_modes ./examples/input/song.mp3
./gfi --mode loop  --intensity 100 --suffix _B_loop  --output-dir ./examples/output/compare_modes ./examples/input/song.mp3
./gfi --mode wreck --intensity 100 --suffix _C_wreck --output-dir ./examples/output/compare_modes ./examples/input/song.mp3
```

Outputs look like: `glitched_song_A_lofi.mp3`, `glitched_song_B_loop.mp3`, `glitched_song_C_wreck.mp3`.

---

## Compare intensity on one mode

Example: only **loop**, from mild to intense.

```bash
mkdir -p ./examples/output/compare_intensity

./gfi --mode loop --intensity 70  --suffix _loop_mild   --output-dir ./examples/output/compare_intensity ./examples/input/song.mp3
./gfi --mode loop --intensity 100 --suffix _loop_default --output-dir ./examples/output/compare_intensity ./examples/input/song.mp3
./gfi --mode loop --intensity 150 --suffix _loop_heavy  --output-dir ./examples/output/compare_intensity ./examples/input/song.mp3
```

Repeat with `--mode lofi` or `--mode wreck` to hear how intensity hits each preset.

---

## Repeatable randomization (`loop` / `wreck`)

`--randomize` nudges internal timing and glitch placement. **`--seed`** makes that nudge repeatable so two runs match.

```bash
./gfi --mode loop --intensity 100 --randomize --seed 42 --suffix _loop_seed42 ./examples/input/song.mp3
./gfi --mode wreck --intensity 120 --randomize --seed 7  --suffix _wreck_seed7 ./examples/input/song.mp3
```

Same `seed` + same input → same result; change the seed for a different “roll.”

---

## Full mode × intensity matrix (one command)

Renders **lofi**, **loop**, and **wreck** at intensities **60**, **100**, and **140** (nine files total):

```bash
chmod +x ./examples/render_comparison_pack.sh
./examples/render_comparison_pack.sh ./examples/input/song.mp3
```

Optional second argument: output directory (default `./examples/output/compare/`).

Filenames encode mode and intensity, e.g. `glitched_song_lofi_i060.mp3`, `glitched_song_loop_i100.mp3`, `glitched_song_wreck_i140.mp3`.

---

## Manual matrix (same as the script, copy/paste)

If you prefer explicit commands:

```bash
mkdir -p ./examples/output/compare
IN=./examples/input/song.mp3

./gfi --mode lofi  --intensity 60  --suffix _lofi_i060  --output-dir ./examples/output/compare "$IN"
./gfi --mode lofi  --intensity 100 --suffix _lofi_i100  --output-dir ./examples/output/compare "$IN"
./gfi --mode lofi  --intensity 140 --suffix _lofi_i140  --output-dir ./examples/output/compare "$IN"

./gfi --mode loop  --intensity 60  --suffix _loop_i060  --output-dir ./examples/output/compare "$IN"
./gfi --mode loop  --intensity 100 --suffix _loop_i100  --output-dir ./examples/output/compare "$IN"
./gfi --mode loop  --intensity 140 --suffix _loop_i140  --output-dir ./examples/output/compare "$IN"

./gfi --mode wreck --intensity 60  --suffix _wreck_i060 --output-dir ./examples/output/compare "$IN"
./gfi --mode wreck --intensity 100 --suffix _wreck_i100 --output-dir ./examples/output/compare "$IN"
./gfi --mode wreck --intensity 140 --suffix _wreck_i140 --output-dir ./examples/output/compare "$IN"
```

---

## Basic remix (default mode and intensity)

```bash
./gfi ./examples/input/song.mp3
```

Equivalent to `--mode lofi --intensity 100` and default MP3 export next to the input (unless you set `--output-dir`).

---

## Texture layering

Specific file:

```bash
./gfi --mode wreck --intensity 110 --texture ./textures/vinyl-crackle.wav --texture-level -21 \
  --suffix _with_texture --output-dir ./examples/output ./examples/input/song.mp3
```

Random texture from `textures/`:

```bash
./gfi --mode wreck --texture random --suffix _texrand ./examples/input/song.mp3
```

---

## Alternate formats

```bash
./gfi --format flac --output-dir ./examples/output ./examples/input/song.wav
./gfi --format ogg --bitrate 160k ./examples/input/song.wav
```

---

## Static video export (MP4)

Solid color:

```bash
./gfi --mode loop --video-color '#081018' --output-dir ./examples/output ./examples/input/song.wav
```

Cover image:

```bash
./gfi --video-image ./cover.png --output-dir ./examples/output ./examples/input/song.wav
```

---

## Batch conversion (one mode, many files)

Processes every supported audio file in a directory with the same mode and extra flags:

```bash
./examples/batch_glitchify.sh loop ./examples/input ./examples/output --randomize --seed 9
```

Arguments: `mode` `input_dir` `output_dir` then any extra `gfi` options (e.g. `--intensity 130`).

---

## Project smoke test

```bash
./scripts/smoke-test.sh
```

---

## Output naming reminder

With `--output-dir ./examples/output` and no custom `--output`, files are named:

`glitched_<input_stem><suffix>.<format>`

Example: input `song.mp3`, `--suffix _demo` → `glitched_song_demo.mp3`.

Use `--force` to overwrite an existing file of the same name.
