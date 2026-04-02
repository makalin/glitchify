# Glitchify

Glitchify, temiz ses dosyalarini bozulmus, nostaljik, kirik ve sinematik glitch dokularina donusturen macOS odakli bir komut satiri ses aracidir.

Pratik komut satiri giris noktasi `gfi` komutudur. `glitchify.sh` dosyasi ise geriye donuk uyumluluk icin korunur.

`ffmpeg` + `sox` tabanli kararlı bir isleme zinciri kullanir ve tek seferlik bir betikten daha kullanisli bir araca donusur:

- kisa komut adi
- icerik ureticilerine uygun modlar
- ayarlanabilir etki yogunlugu
- seed ile tekrar uretilebilir rastgelelestirme
- istege bagli texture katmani
- farkli ses cikis formatlari
- sosyal medya icin basit sabit goruntulu video cikisi
- toplu isleme ve smoke test betikleri

## Son Degisiklikler

- pratik kisa CLI adi: `gfi`
- `glitchify.sh` uyumluluk sarmalayicisi olarak korunur
- ses modlari `lofi`, `loop` ve `wreck` olarak sadeleştirildi
- mikro tempo dalgalanmasi ve needle-loop glitch davranisi eklendi
- `loop` ve `wreck` modlari daha belirgin skip benzeri efektler uretir
- smoke test artik hem ses hem MP4 cikisini dogrular

## Ozellikler

Glitchify su isleme zincirini uygular:

1. kaynak sesi calisma WAV dosyasina cevirir
2. downsample ve band daraltma ile bozar
3. kaset benzeri hareket ekler
4. mikro tempo dalgalanmasi uygular
5. reverb ve drive katmani ekler
6. istege bagli texture katmani karistirir
7. needle-loop glitch ve bazen reverse kesitler ekler
8. ses ve istege bagli video cikisi uretir

Modlar:

- `lofi`: muzikalligi koruyan hafif drift ve tek temiz loop
- `loop`: needle-loop ve skip etkisini daha belirgin kullanir
- `wreck`: daha sert, daha kirik ve daha dengesiz bir sonuc verir

Efekt karakteri:

- `lofi` gercek parcalar icin en guvenli varsayilan moddur
- `loop` daha cok plak atlamasi / needle-loop hissine odaklanir
- `wreck` loop glitch, drift, texture ve bazen reverse parcalari birlestirir

## Kurulum

### 1. Homebrew kur

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Bagimliliklari kur

Elle kurulum:

```bash
brew install ffmpeg sox
```

Yardimci betik ile:

```bash
chmod +x scripts/install-deps.sh
./scripts/install-deps.sh
```

### 3. Projeyi klonla ve hazirla

```bash
git clone https://github.com/frangedev/glitchify.git
cd glitchify
chmod +x gfi glitchify.sh examples/batch_glitchify.sh scripts/install-deps.sh scripts/smoke-test.sh
```

## Hizli Baslangic

```bash
./gfi ./path/to/song.mp3
```

Bu komut, girdi dosyasinin yanina `glitched_` on ekiyle yeni bir dosya yazar.

## Kullanim

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

## Ornekler

Temel kullanim:

```bash
./gfi song.mp3
```

Daha agresif:

```bash
./gfi --mode wreck --intensity 150 song.wav
```

Tekrar uretilebilir rastgele render:

```bash
./gfi --mode loop --randomize --seed 42 song.wav
```

Texture katmani:

```bash
./gfi --texture random --texture-level -20 song.mp3
```

Ogg cikisi:

```bash
./gfi --format ogg --bitrate 160k song.wav
```

Sosyal medya icin MP4:

```bash
./gfi --video-color '#081018' --output-dir ./exports song.wav
```

Daha fazla calisabilir ornek icin [examples/README.md](examples/README.md) dosyasina bakin.

## Guvenlik Notlari

Mevcut shell yuzeyini temel guvenlik riskleri icin gozden gecirdim.

- `eval` kullanilmiyor
- harici komutlar quoted argumanlarla cagriliyor
- gecici dosyalar `mktemp` ile ve ozel izinlerle olusturuluyor
- ustune yazma davranisi yalnizca `--force` ile aktif oluyor
- `--video-color` ffmpeg'e gitmeden once hex formatinda dogrulaniyor

Mevcut sinirlar:

- bu arac, gosterdiginiz yerel dosyalar uzerinde `ffmpeg` ve `sox` calistiran bir CLI olmaya devam ediyor
- texture taramasi normal dosya adlarini hedefliyor; kotu niyetli newline iceren dosya adlari icin ekstra sertlestirme yok
- bu ortamda `shellcheck` kurulu olmadigi icin onu calistiramadim

## Proje Yapisi

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

## Yayginlasma Icin Sonraki Adimlar

Bu aracin yayilmasi icin su adimlar mantikli:

- Homebrew tap olarak paketlemek
- daha zengin videolar icin waveform veya kapak gorseli sablonlari eklemek
- `textures/` klasorune baslangic texture paketleri koymak
- sosyal kanit icin `demo/` klasorunde ornek once/sonra cikislari yayinlamak
- `scripts/smoke-test.sh` calistiran bir CI eklemek

## Lisans

Bu proje MIT License ile lisanslanmistir. Ayrinti icin [LICENSE](LICENSE) dosyasina bakin.
