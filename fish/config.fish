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

abbr -a --position anywhere ss sudo
if test "$os" = Darwin
    abbr -a --position anywhere b brew
else if test "$os" = Linux
    abbr -a j journalctl
    abbr -a pc --position anywhere pacman
end

# --- FZF ---

set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_diff_highlighter delta --paging=never --width=20
fzf_configure_bindings --directory=ctrl-alt-f
fzf_configure_bindings --git_log=ctrl-alt-l
fzf_configure_bindings --git_status=ctrl-alt-s
fzf_configure_bindings --processes=ctrl-alt-p

# --- Functions ---

function take
    mkdir -p $argv[1]
    cd $argv[1]
end
