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
- `input.lua` — Czech QWERTZ + US layouts, switch with Left Alt + Right Alt, Caps Lock as compose key

**Keyboard layout**
- Hyprland: `cz,us` (`.config/hypr/input.lua`)
- fcitx5: Czech keyboard as the default input method (`.config/fcitx5/`)
- Console / TTY: `KEYMAP=cz` (`system/etc/vconsole.conf`, applied by `install.sh` via `localectl`)
- Windows-style `Ctrl+Alt` symbols (`.config/hypr/bindings.lua`, see Keys below)

**Terminal**
- foot with extra padding, `Ctrl+V` paste, copy-on-select
- fastfetch with a black-hole logo on every new terminal
- History picker under the prompt on every new terminal (`.config/bash/void-picker.bash`)
- Starship prompt with a violet `◆`
- Black-hole screensaver art

**Chromium**
- `void-pip` extension: `Alt+P` floats the page's video into the picture-in-picture card
- On YouTube the card gets a Skip Ad button while an ad plays (skips it, or jumps to the end of unskippable ones)

## Keys

| Keys | Does |
|---|---|
| `Alt+P` (in Chromium) | Float / unfloat the video |
| `Super+Alt+P` | Play / pause media |
| `Super+Alt+Y` | Jump to the floating video's desktop |
| `Ctrl+Alt+V` | `@` (also `Q` `\`, `W` `\|`, `E` `€`, `X` `#`, `C` `&`, `F` `[`, `G` `]`, `B` `{`, `N` `}`, `,` `<`, `.` `>`) |
| `Left Alt + Right Alt` | Switch Czech / US layout |

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
