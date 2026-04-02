# Examples

These examples assume you are running commands from the project root.

## Basic remix

```bash
./gfi ./examples/input/song.mp3
```

## Higher-intensity broken preset

```bash
./gfi --mode wreck --intensity 145 ./examples/input/song.wav
```

## Repeatable randomization

```bash
./gfi --mode loop --randomize --seed 42 ./examples/input/song.wav
```

## Texture layering

Use a specific texture file:

```bash
./gfi --texture ./textures/vinyl-crackle.wav --texture-level -21 ./examples/input/song.mp3
```

Use a random texture from the `textures/` folder:

```bash
./gfi --texture random ./examples/input/song.mp3
```

## Alternate formats

```bash
./gfi --format flac --output-dir ./exports ./examples/input/song.wav
./gfi --format ogg --bitrate 160k ./examples/input/song.wav
```

## Static-video export

Render a simple MP4 with a solid color:

```bash
./gfi --video-color '#081018' ./examples/input/song.wav
```

Render a simple MP4 with a cover image:

```bash
./gfi --video-image ./cover.png ./examples/input/song.wav
```

## Batch conversion

```bash
./examples/batch_glitchify.sh loop ./examples/input ./examples/output --randomize --seed 9
```

## Project smoke test

```bash
./scripts/smoke-test.sh
```
