# Glitchify

[English](README.md) | Türkçe

Glitchify, temiz ses dosyalarını bozulmuş, nostaljik, kırık ve sinematik glitch dokularına dönüştüren macOS odaklı bir komut satırı ses aracıdır.

Pratik komut satırı giriş noktası `gfi` komutudur. `glitchify.sh` dosyası ise geriye dönük uyumluluk için korunur.

`ffmpeg` + `sox` tabanlı kararlı bir işleme zinciri kullanır ve tek seferlik bir betikten daha kullanışlı bir araca dönüşür:

- kısa komut adı
- içerik üreticilerine uygun modlar
- ayarlanabilir etki yoğunluğu
- seed ile tekrar üretilebilir rastgeleleştirme
- isteğe bağlı texture katmanı
- farklı ses çıkış formatları
- sosyal medya için basit sabit görüntülü video çıkışı
- toplu işleme ve smoke test betikleri

## Son Değişiklikler

- pratik kısa CLI adı: `gfi`
- `glitchify.sh` uyumluluk sarmalayıcısı olarak korunur
- ses modları `lofi`, `loop` ve `wreck` olarak sadeleştirildi
- mikro tempo dalgalanması ve needle-loop glitch davranışı eklendi
- `loop` ve `wreck` modları daha belirgin skip benzeri efektler üretir
- smoke test artık hem ses hem MP4 çıkışını doğrular

## Özellikler

Glitchify şu işleme zincirini uygular:

1. kaynak sesi çalışma WAV dosyasına çevirir
2. downsample ve band daraltma ile bozar
3. kaset benzeri hareket ekler
4. mikro tempo dalgalanması uygular
5. reverb ve drive katmanı ekler
6. isteğe bağlı texture katmanı karıştırır
7. needle-loop glitch ve bazen reverse kesitler ekler
8. ses ve isteğe bağlı video çıkışı üretir

Modlar:

- `lofi`: müzikalliği koruyan hafif drift ve tek temiz loop
- `loop`: needle-loop ve skip etkisini daha belirgin kullanır
- `wreck`: daha sert, daha kırık ve daha dengesiz bir sonuç verir

Efekt karakteri:

- `lofi` gerçek parçalar için en güvenli varsayılan moddur
- `loop` daha çok plak atlaması / needle-loop hissine odaklanır
- `wreck` loop glitch, drift, texture ve bazen reverse parçaları birleştirir

## Kurulum

### 1. Homebrew kur

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Bağımlılıkları kur

Elle kurulum:

```bash
brew install ffmpeg sox
```

Yardımcı betik ile:

```bash
chmod +x scripts/install-deps.sh
./scripts/install-deps.sh
```

### 3. Projeyi klonla ve hazırla

```bash
git clone https://github.com/frangedev/glitchify.git
cd glitchify
chmod +x gfi glitchify.sh examples/batch_glitchify.sh examples/render_comparison_pack.sh scripts/install-deps.sh scripts/smoke-test.sh
```

## Hızlı Başlangıç

```bash
./gfi ./path/to/song.mp3
```

Bu komut, girdi dosyasının yanına `glitched_` ön ekiyle yeni bir dosya yazar.

## Kullanım

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

## Örnekler

Temel kullanım:

```bash
./gfi song.mp3
```

Daha agresif:

```bash
./gfi --mode wreck --intensity 150 song.wav
```

Tekrar üretilebilir rastgele render:

```bash
./gfi --mode loop --randomize --seed 42 song.wav
```

Texture katmanı:

```bash
./gfi --texture random --texture-level -20 song.mp3
```

Ogg çıkışı:

```bash
./gfi --format ogg --bitrate 160k song.wav
```

Sosyal medya için MP4:

```bash
./gfi --video-color '#081018' --output-dir ./exports song.wav
```

Daha fazla çalışabilir örnek için [examples/README.md](examples/README.md) dosyasına bakın.

## Web demosu (GitHub Pages)

Kök dizindeki [`index.html`](index.html), [`test/`](test/) içindeki dosyaları çalar ([`.gitignore`](.gitignore) istisnaları ile git’e eklenebilir). **Settings → Pages**: **Deploy from a branch** → **main** → **`/` (root)**. [`.nojekyll`](.nojekyll), GitHub’un Jekyll çalıştırmasını kapatır. Site adresi aynı sayfada (proje: `https://<kullanıcı>.github.io/<repo>/`).

## Güvenlik Notları

Mevcut shell yüzeyini temel güvenlik riskleri için gözden geçirdim.

- `eval` kullanılmıyor
- harici komutlar quoted argümanlarla çağrılıyor
- geçici dosyalar `mktemp` ile ve özel izinlerle oluşturuluyor
- üstüne yazma davranışı yalnızca `--force` ile aktif oluyor
- `--video-color` ffmpeg'e gitmeden önce hex formatında doğrulanıyor

Mevcut sınırlar:

- bu araç, gösterdiğiniz yerel dosyalar üzerinde `ffmpeg` ve `sox` çalıştıran bir CLI olmaya devam ediyor
- texture taraması normal dosya adlarını hedefliyor; kötü niyetli newline içeren dosya adları için ekstra sertleştirme yok
- bu ortamda `shellcheck` kurulu olmadığı için onu çalıştıramadım

## Proje Yapısı

```text
.
├── gfi
├── glitchify.sh
├── index.html
├── test
│   └── (Pages için demo WAV/MP3)
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
├── .nojekyll
├── LICENSE
└── README.md
```

## Yaygınlaşma İçin Sonraki Adımlar

Bu aracın yayılması için şu adımlar mantıklı:

- Homebrew tap olarak paketlemek
- daha zengin videolar için waveform veya kapak görseli şablonları eklemek
- `textures/` klasörüne başlangıç texture paketleri koymak
- sosyal kanıt için `demo/` klasöründe örnek önce/sonra çıkışları yayınlamak
- `scripts/smoke-test.sh` çalıştıran bir CI eklemek

## Lisans

Bu proje MIT License ile lisanslanmıştır. Ayrıntı için [LICENSE](LICENSE) dosyasına bakın.
