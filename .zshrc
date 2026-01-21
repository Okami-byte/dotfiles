# Starship ----------------------------------------
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Install Homebrew -------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode
zinit load atuinsh/atuin

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons=always $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# fzf extras ----------------------------------------
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# Setting nvim as default editor ----------------------------------------
if [ $(command -v nvim) ]; then
  export EDITOR=$(which nvim)
  alias vim=$EDITOR
  alias nv=$EDITOR
fi

export SUDO_EDITOR=$EDITOR
export VISUAL=$EDITOR
export FZF_DEFAULT_OPS="--extended"

# Python
export PATH="${PATH}:/Users/fox/Library/Python/3.11/lib/python/site-packages"

# Colored manpages
# Use bat to view man pages
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#
# Use Nvim as the manpage viewer
export MANPAGER="nvim +Man!"

# Aliases

alias ll="eza -l --icons --git "
alias ls="eza --color=always --grid --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias la="eza -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias vimm="vim"
alias x="exit"
alias gn="sudo shutdown -h now"
alias cat="bat"
alias z="zoxide"
alias sv="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"
alias ya="yazi"
alias d="delta"
alias yt="yt-dlp"
alias f="fastfetch"
alias sp="spotify_player"
alias wifi="wifi-password"
alias py="python3"
alias rm="trash"
alias ping="ping -c 5"
alias cp="cp -iv"
alias mv="mv -iv"

# Sesh
# alias s="./.dotfiles/scripts/sesh_start"

# Nmap
alias nm="nmap -sC -sV -oN nmap-output.txt"

#git aliases

alias ga='git add -A'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gdiff='git diff'
alias gdc='git diff --cached'
alias gcm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpl='git pull'
alias gcl='git clone'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Aerospace listing
# def ff () {
# aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
# }

# Alias for yabai window listing
def ff() {
  yabai -m query --windows | jq -r '.[] | "\(.id) \(.app) - \(.title)"' | \
  fzf --bind 'enter:execute(yabai -m window --focus {1})+abort'
}

deff s() {
sesh connect "$(
  sesh list --icons --hide-duplicates | fzf --no-border \
    --ansi \
    --list-border \
    --no-sort --prompt '   ' \
    --color 'list-border:6,input-border:3,preview-border:4,header-bg:-1,header-border:6' \
    --input-border \
    --header-border \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(   )+reload(sesh list --icons)' \
    --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t --icons)' \
    --bind 'ctrl-g:change-prompt(   )+reload(sesh list -c --icons)' \
    --bind 'ctrl-x:change-prompt(󰉋   )+reload(sesh list -z --icons)' \
    --bind 'ctrl-f:change-prompt(󰭎   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
    --preview-window 'right:70%' \
    --preview 'sesh preview {}'
)"
}

# VI Mode!!!
bindkey jj vi-cmd-mode


#Create a directory and cd diretctly into it
function take {
    mkdir -p $1
    cd $1
}

# Drop into fish if:
# - The parent process isn't fish.
# - Not running a command like `zsh -c 'echo foo'`.
# - This is the top-level shell.
if [[ $(ps -p $PPID -o comm=) != "fish" && -z ${ZSH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
    # Check if this is a login shell using zsh options
    if [[ ! -o login ]]; then
        exec fish --login
    else
        exec fish
    fi
fi

# Shell integrations  ----------------------------------------

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Using Trash Command to replace rm
export PATH="/opt/homebrew/opt/trash/bin:$PATH"

# Set XDG config home
export XDG_CONFIG_HOME="$HOME/.config"

# Adding Python to path
export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"

export PATH="/Users/fox/.local/bin:$PATH"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# This is for ruby stuff that is required for github blog
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1
# eval "$(atuin init zsh)"

export PATH=$PATH:/Users/fox/.spicetify
