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
done < <(find . -type f -not -path './.git/*' -not -name install.sh -not -name README.md -print0)

# Chromium doesn't expand ~ in its flags file.
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/chromium-flags.conf"

omarchy theme set void
hyprctl reload >/dev/null && hyprctl configerrors

echo "void installed. Replaced files are backed up in $backup"
echo "Restart Chromium and open a new terminal to pick everything up."
