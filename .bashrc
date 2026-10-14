# Drop into fish if:
# - The parent process isn't fish.
# - Not running a command like `bash -c 'echo foo'`.
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  # Let fish whether it's a login shell.
  if ! shopt -q login_shell; then
    exec fish --login
  else
    exec fish
  fi
fi

eval "$(starship init bash)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init bash)"

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
  cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo $'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
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

# Use Nvim as the manpage viewer
export MANPAGER="nvim +Man!"

alias ll="eza -l --icons --git "
alias ls="eza -lh --group-directories-first --git --icons=auto"
alias la="ls -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias lta="lt -a"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias vimm="vim"
alias v="$EDITOR"
alias cat="bat"
alias py="python3"
alias pythong="python3"
alias tf="terraform"
alias rm="trash"
alias ping="ping -c 3"
alias cp="cp -iv"
alias mv="mv -iv"
alias stat="stat -x"
alias grep="rg --color=always"
alias cdi='zi'
alias fabric='fabric-ai'
alias ip='ip -color=always'
alias cd='z'

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/fox/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
