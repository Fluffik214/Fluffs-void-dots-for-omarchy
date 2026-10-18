#!/bin/bash
# Install the void rice into $HOME. Every file it replaces is backed up first
# to ~/.omarchy-dots-backup/<timestamp>/.
set -euo pipefail

cd "$(dirname "$0")"
backup="$HOME/.omarchy-dots-backup/$(date +%Y%m%d-%H%M%S)"

while IFS= read -r -d '' file; do
  rel=${file#./}
  target="$HOME/$rel"
  if [[ -e $target ]]; then
    mkdir -p "$backup/$(dirname "$rel")"
    cp -a "$target" "$backup/$rel"
  fi
  mkdir -p "$(dirname "$target")"
  cp -a "$file" "$target"
done < <(find . -type f -not -path './.git/*' -not -path './system/*' -not -name install.sh -not -name README.md -print0)

# Chromium doesn't expand ~ in its flags file.
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/chromium-flags.conf"

# Keyboard: Czech console keymap (system-wide, needs sudo) and reload fcitx5.
keymap=$(sed -n 's/^KEYMAP=//p' system/etc/vconsole.conf)
if [[ -n $keymap && $(localectl status | sed -n 's/.*VC Keymap: //p') != "$keymap" ]]; then
  sudo localectl set-keymap "$keymap"
fi
command -v fcitx5-remote >/dev/null && fcitx5-remote -r 2>/dev/null || true

omarchy theme set void
hyprctl reload >/dev/null && hyprctl configerrors

echo "void installed. Replaced files are backed up in $backup"
echo "Restart Chromium and open a new terminal to pick everything up."
