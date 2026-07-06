#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/
# cSpell:words shellcode pkgx direnv

# --- Bootstrap ---

eval (/opt/homebrew/bin/brew shellenv)
# command -q zoxide; and zoxide init fish | source # 'ajeetdsouza/zoxide'
zoxide init fish | source

if not status is-interactive
    return 0
end

set -l os (uname)

# --- Shell Integration ---

if test -n "$GHOSTTY_RESOURCES_DIR"
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end

# --- Prompt ---

function starship_transient_prompt_func
    starship module character
end
command -q starship; and starship init fish | source
enable_transience

# --- Environment ---

set -U fish_greeting
set -Ux EDITOR nvim
export MANPAGER="nvim +Man!"

# --- Vi Mode ---

set -g fish_key_bindings fish_vi_key_bindings
function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# --- Paths ---

fish_add_path $HOME/Developer/scripts
fish_add_path --path /opt/homebrew/opt/trash/bin
fish_add_path --path /opt/homebrew/opt/python@3.13/libexec/bin
fish_add_path --path /Users/fox/.local/bin
fish_add_path --path /Users/fox/.cargo/bin
fish_add_path --path XDG_CONFIG_HOME=$HOME/.config/
fish_add_path --path /opt/homebrew/bin/bun

# --- Completions ---

if test "$os" = Darwin
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

# --- Abbreviations ---

# I currently don't have a use for this, so I'll come and revisit another time if I find a use.

# --- FZF ---

set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_diff_highlighter delta --paging=never --width=20
fzf_configure_bindings --directory=ctrl-f
fzf_configure_bindings --git_log=ctrl-alt-l
fzf_configure_bindings --git_status=ctrl-alt-s
fzf_configure_bindings --processes=ctrl-alt-p

# --- Functions ---

function take
    mkdir -p $argv[1]
    cd $argv[1]
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
