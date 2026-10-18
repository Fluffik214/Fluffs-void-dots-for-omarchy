# void picker — an fzf list under the prompt when a terminal opens.
#
#   ↑/↓ move · type to filter · Tab/Enter puts the command on the line · Esc skips
#
#   commands      open the picker once over every available command
#   commands -s   make new terminals show commands instead of history
#   history       switch new terminals back to history
#                 (history with arguments still runs the bash builtin)

_VOID_PICKER_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/void/picker-mode"

_void_picker_mode() {
  local mode
  [[ -r $_VOID_PICKER_STATE ]] && read -r mode < "$_VOID_PICKER_STATE"
  [[ $mode == commands ]] && echo commands || echo history
}

_void_picker_set_mode() {
  mkdir -p "${_VOID_PICKER_STATE%/*}"
  echo "$1" > "$_VOID_PICKER_STATE"
  echo "◆ picker: $1"
}

_void_picker_list() {
  if [[ $1 == commands ]]; then
    compgen -A function -abck | grep -v '^_' | sort -u
  else
    builtin fc -lnr 1 2>/dev/null | sed 's/^[[:space:]]*//' | awk 'NF && !seen[$0]++'
  fi
}

_void_picker() {
  local mode=${_VOID_PICKER_ONCE:-$(_void_picker_mode)} selected
  unset _VOID_PICKER_ONCE

  selected=$(_void_picker_list "$mode" | fzf \
    --height=40% --layout=reverse --border=rounded --no-multi \
    --query="$READLINE_LINE" --prompt="◆ " --pointer="▌" --marker="" \
    --info=inline-right --header="$mode · tab pick · esc skip" \
    --bind="tab:accept" \
    --color="bg+:#101014,fg:#9898a6,fg+:#eeeef4,hl:#8b7cf6,hl+:#bba8f0" \
    --color="pointer:#8b7cf6,prompt:#8b7cf6,border:#2a2440,header:#4a4a56,info:#4a4a56,gutter:-1")

  if [[ -n $selected ]]; then
    READLINE_LINE=$selected
    READLINE_POINT=${#selected}
  fi
}

# The terminal answers a status query (ESC[5n) with ESC[0n, which readline
# reads as a keypress at the next prompt — that keypress opens the picker.
bind -x '"\e[0n": _void_picker'

_void_picker_trigger() {
  local saved i
  saved=$(stty -g 2>/dev/null) || return

  # Keep the reply off the screen: hold echo off until it is sitting in the input queue.
  stty -echo -icanon min 0 time 0
  printf '\e[5n'
  for ((i = 0; i < 30; i++)); do
    read -t 0 && break
    sleep 0.01
  done
  stty "$saved"
}

commands() {
  case $1 in
  "") _VOID_PICKER_ONCE=commands; _void_picker_trigger ;;
  -s) _void_picker_set_mode commands ;;
  *) echo "usage: commands [-s]" >&2; return 1 ;;
  esac
}

history() {
  if (($# == 0)); then
    _void_picker_set_mode history
  else
    builtin history "$@"
  fi
}

# Save each command as soon as it runs, so new terminals see it in the picker.
[[ $PROMPT_COMMAND == *"history -a"* ]] || PROMPT_COMMAND="builtin history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
