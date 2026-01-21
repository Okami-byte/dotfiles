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

# Nothing to do if not inside an interactive shell.
if not status is-interactive
    return 0
end

# Figure out which operating system we're in
set -l os (uname)

# Set up Ghostty's shell integration.
if test -n "$GHOSTTY_RESOURCES_DIR"
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end

# Remove the gretting message.
set -U fish_greeting

# Vi mode.
set -g fish_key_bindings fish_vi_key_bindings
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# Set neovim as default editor
set -Ux EDITOR nvim # 'neovim/neovim' text editor

zoxide init fish | source # ajeetdsouza/zoxide
atuin init fish | source # https://github.com/atuinsh/atuin

# System maintenance.
abbr -a --position anywhere ss sudo
if test "$os" = Darwin
    abbr -a --position anywhere b brew
else if test "$os" = Linux
    abbr -a j journalctl
    abbr -a pc --position anywhere pacman
end

# Add completions from stuff installed with Homebrew.
if test "$os" = Darwin
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

# FZF Custom Configs
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_diff_highlighter delta --paging=never --width=20

# $PATHS

# Scripts
fish_add_path $HOME/Developer/Scripts # my custom scripts

# Using Trash Command to replace rm
fish_add_path --path /opt/homebrew/opt/trash/bin

# Set XDG config home
fish_add_path XDG_CONFIG_HOME=$HOME/.config

# Adding Python to path
fish_add_path --path /opt/homebrew/opt/python@3.13/libexec/bin

fish_add_path --path /Users/fox/.local/bin

# Adding cargo to path
fish_add_path --path /Users/fox/.cargo/bin

# Use Nvim as the manpage viewer
export MANPAGER="nvim +Man!"

# Starship transient prompt for fish
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

# Function to create a directory and cd diretctly into it
function take
    mkdir -p $argv[1]
    cd $argv[1]
end
