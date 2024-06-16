# Wallpapers

Using [wallpapper](https://github.com/mczachurski/wallpapper) by mczachurski, this creates dynamic wallpapers for macOS.

## Installation

```bash
cd $HOME/dotfiles/system/wallpapers/wallpapper/
./build.sh
sudo cp .output/wallpapper /usr/local/bin
sudo cp .output/wallpapper-exif /usr/local/bin
```

## Usage

Usage is very simple, and you can refer to the original repo's
[README](https://github.com/mczachurski/wallpapper#getting-started). I'm personally using it based on OS apperance
settings (light/dark), which is also the simples API to use.

Under `images`, create a folder with the name of your choice. Inside this folder, put an image for the light theme, and
one for the dark theme.

Under the same folder, create a `config.json` file as follows:

```json
[
  {
    "fileName": "1.png",
    "isPrimary": true,
    "isForLight": true
  },
  {
    "fileName": "2.png",
    "isForDark": true
  }
]
```

Once this is setup, navigate to this folder and run

```bash
wallpapper -i config.json
```

This will in turn create an `output.heic` image, that you can now safely set as a dynamic wallpaper.

For more information, run

```bash
wallpapper -h
```
