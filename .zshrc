# Starship ----------------------------------------
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml

# Transient prompt (parity with fish's enable_transience) ----------------------------------------
autoload -Uz add-zsh-hook add-zle-hook-widget

# Starship transient prompt
function transient-prompt-precmd {
  # Fix ctrl+c behavior
  TRAPINT() { transient-prompt; return $(( 128 + $1 )) }
}
add-zsh-hook precmd transient-prompt-precmd

function transient-prompt {
  PROMPT="$(starship module character)" RPROMPT='' zle .reset-prompt
}
add-zle-hook-widget zle-line-finish transient-prompt

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Vi-mode cursor shapes (parity with fish's fish_vi_key_bindings cursor config)
function zvm_config() {
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
}

# Add in zsh plugins
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"0" lucid depth=1
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode
zinit load atuinsh/atuin

# Load completions — only re-run the (slow) security audit once a day;
# otherwise trust the cached dump (saves ~150-200ms per startup).
fpath=(/Users/fox/.zsh/completions $fpath)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# VI Mode!!!
bindkey jj vi-cmd-mode

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

# Colored manpages
# Use bat to view man pages
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#
# Use Nvim as the manpage viewer
export MANPAGER="nvim +Man!"

# PATH ----------------------------------------
export PATH="/opt/homebrew/opt/trash/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Developer/scripts:$PATH"
export PATH="$HOME/.config/scripts:$PATH"
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/fox/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Aliases

alias ll="eza -l --icons --git "
alias ls="eza -lh --group-directories-first --git --icons=auto"
alias la="ls -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias lta="lt -a"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias py="python3"
alias pythong="python3"
alias tf="terraform"
alias k="kubectl"
alias stat="stat -x"
alias grep="rg --color=always"
alias fabric='fabric-ai'
alias ip='ip -color=always'
alias ss='ss -color=always'
alias vimm="vim"
alias v="$EDITOR"
alias x="exit"
alias gn="sudo shutdown -h now"
alias cat="bat"
alias sv="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"
alias ya="yazi"
alias d="delta"
alias yt="xytz"
alias sp="spotatui"
alias py="python3"
alias rm="trash"
alias ping="ping -c 3"
alias cp="cp -iv"
alias mv="mv -iv"

# Nmap
alias nm="nmap -sC -sV -oN nmap-output.txt"

# git aliases

alias ga='git add -A'
alias gp='git push'
alias gl='git log'
alias gdiff='git diff'
alias gdc='git diff --cached'
alias gcm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gco='git checkout'
alias gf='git fetch'
alias gm='git merge'
alias gs='git status'
alias gst='git status --short'
alias glg='git log --graph --oneline --all'
alias glo='serie'
alias gra='git remote add'
alias grr='git remote rm'
alias gpl='git pull'
alias gcl='git clone'
alias lg='lazygit'

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
alias -- -='cd -'

# Brew
alias bu="brew update"
alias bug="brew upgrade"
alias bo="brew outdated"
alias bi="brew install"
alias bic="brew install --cask"
alias bin="brew info"
alias binc="brew info --cask"
alias bl="brew leaves"
alias blr="brew leaves --installed-on-request"
alias blp="brew leaves --installed-as-dependency"
alias bs="brew search"

# AI
alias ca="claude"
alias cc="claude --dangerously-skip-permissions"

# Oh My Pi
alias o="omp"

# Espanso
alias ee="espanso edit"
alias er="espanso restart"

# LazyDocker
alias ld="lazydocker"

# Neovim
alias nvp="nvim +Man!"

# Herdr
alias h="herdr_start"

# System commands
alias pwdc="pwd | pbcopy"

# Tmux
alias tn="tmux new-session -s"
alias tl="tmux list-sessions"
alias ta="tmux attach-session"

# Sesh — zsh's richer fzf picker is retired in favor of sesh's own picker,
# which the upstream author is actively extending with window/pane nav.
# Revisit once sesh ships that, possibly porting a custom picker to both shells.
alias s="sesh picker -idH"

#Create a directory and cd diretctly into it
function take {
    mkdir -p $1
    cd $1
}

# # Styled sesh picker (superseded by `sesh picker -idH` above — kept for
# # reference in case we build a custom window/pane-aware picker later)
# deff s() {
# sesh connect "$(
#   sesh list --icons --hide-duplicates | fzf --no-border \
#     --ansi \
#     --list-border \
#     --no-sort --prompt '   ' \
#     --color 'list-border:6,input-border:3,preview-border:4,header-bg:-1,header-border:6' \
#     --input-border \
#     --header-border \
#     --bind 'tab:down,btab:up' \
#     --bind 'ctrl-a:change-prompt(   )+reload(sesh list --icons)' \
#     --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t --icons)' \
#     --bind 'ctrl-g:change-prompt(   )+reload(sesh list -c --icons)' \
#     --bind 'ctrl-x:change-prompt(󰉋   )+reload(sesh list -z --icons)' \
#     --bind 'ctrl-f:change-prompt(󰭎   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
#     --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
#     --preview-window 'right:70%' \
#     --preview 'sesh preview {}'
# )"
# }

# Shell integrations  ----------------------------------------

. "$HOME/.atuin/bin/env"

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(atuin init zsh)"
