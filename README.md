# void

My [Omarchy](https://omarchy.org/) rice: pure black, cold greys, one ultraviolet accent.

## What's in it

**Theme** — `void` (`.config/omarchy/themes/void/`)
- Black background, soft grey text, `#8b7cf6` accent, desaturated ANSI colors
- Rotating violet gradient border on the focused window
- Three generated wallpapers: starlight (black hole + starfield), event horizon, plain void
- Translucent menus, launcher and notifications with blur behind them

**Hyprland** (`.config/hypr/`)
- `looknfeel.lua` — floaty animations (windows drift in and settle), rounded corners, violet glow on focus, dimmed inactive windows, blur
- `pip.lua` — picture-in-picture video card that follows you across desktops; click it to jump back to the video's desktop, drag it to move it
- `bindings.lua` — Windows-style Czech AltGr: `Ctrl+Alt+V` types `@`, plus `\ | € # & [ ] { } < >`
- `hyprland.lua` — decodes video on the Intel iGPU (hybrid laptop fix for black YouTube videos in Chromium)
- `input.lua` — Czech QWERTZ + US layouts

**Terminal**
- foot with extra padding, `Ctrl+V` paste, copy-on-select
- fastfetch with a black-hole logo on every new terminal
- History picker under the prompt on every new terminal (`.config/bash/void-picker.bash`)
- Starship prompt with a violet `◆`
- Black-hole screensaver art

**Chromium**
- `void-pip` extension: `Alt+P` floats the page's video into the picture-in-picture card

## Keys

| Keys | Does |
|---|---|
| `Alt+P` (in Chromium) | Float / unfloat the video |
| `Super+Alt+P` | Play / pause media |
| `Super+Alt+Y` | Jump to the floating video's desktop |
| `Ctrl+Alt+V` | `@` |

## Picker commands

| Command | Does |
|---|---|
| `commands` | Open the picker over every available command |
| `commands -s` | New terminals show commands instead of history |
| `history` | New terminals show history again (`history` with arguments is the normal builtin) |

In the picker: arrows move, type to filter, `Tab`/`Enter` puts the command on the line, `Esc` skips.

## Install

```bash
git clone https://github.com/Fluffik214/omarchy-dots.git
cd omarchy-dots
./install.sh
```

Every file it replaces is backed up to `~/.omarchy-dots-backup/<timestamp>/`.
