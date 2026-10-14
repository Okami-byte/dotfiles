# Runs once per login shell (new Terminal/iTerm/kitty window, new tmux pane).
# Keep this file cheap: only things that must exist before any interactive
# plugin manager (zinit) or prompt (starship) starts.

# Homebrew ----------------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Machine-local secrets / env (gitignored, see .dotfiles/.env) ----------------------------------------
[[ -f "$HOME/.dotfiles/.env" ]] && source "$HOME/.dotfiles/.env"

# XDG ----------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
