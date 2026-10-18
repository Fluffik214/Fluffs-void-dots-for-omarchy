# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# void: greet each new terminal with fastfetch (skipped in nested shells, nvim, and tmux panes)
if [[ -z $FASTFETCH_SHOWN && -z $NVIM && -z $TMUX ]] && command -v fastfetch >/dev/null; then
  export FASTFETCH_SHOWN=1
  fastfetch
  _void_greet=1
fi

# void: history/commands picker under the prompt (see ~/.config/bash/void-picker.bash)
if [[ -r ~/.config/bash/void-picker.bash ]] && command -v fzf >/dev/null; then
  source ~/.config/bash/void-picker.bash
  [[ -n $_void_greet ]] && _void_picker_trigger
fi
unset _void_greet
