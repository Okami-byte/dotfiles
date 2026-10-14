# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/

# --- Bootstrap ---

eval (/opt/homebrew/bin/brew shellenv)
command -q zoxide; and zoxide init fish --cmd cd | source # 'ajeetdsouza/zoxide'

if not status is-interactive
    return 0
end

set -l os (uname)

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

set -gx XDG_CONFIG_HOME $HOME/.config
fish_add_path $HOME/Developer/scripts
fish_add_path --path /opt/homebrew/opt/trash/bin
fish_add_path --path /opt/homebrew/opt/python@3.13/libexec/bin
fish_add_path --path /Users/fox/.local/bin
fish_add_path --path /Users/fox/.cargo/bin
fish_add_path --path /Users/fox/.config/scripts

# --- Completions ---

# Brew completions added
if test "$os" = Darwin
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

# --- System maintenance ---
if test "$os" = Darwin
    abbr -a --position anywhere b brew
else if test "$os" = Linux
    abbr -a j journalctl
    abbr -a pc --position anywhere pacman
end

# --- Abbreviations ---

# I currently don't have a use for this, so I'll come and revisit another time if I find a use.

# --- FZF ---

set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_diff_highlighter delta --paging=never --width=20

# fzf.fish's default ctrl-alt-l (Search Git Log) still collides with
# skhd/yabai's lctrl+alt-l window-warp hotkey (~/.dotfiles/skhd/skhdrc).
# ctrl-alt-f/s are clear now that those skhd bindings were removed.
# ctrl-r is already owned by atuin.
fzf_configure_bindings --git_log=ctrl-alt-c --history=

# --- Functions ---

function take
    mkdir -p $argv[1]
    cd $argv[1]
end

# bangbang: make a function that gets last item in history, and an
#           abbreviation that uses it wherever you type !!

function last_history_item -d "Get the last executed item from history"
    history --max=1
end

abbr -a !! --position anywhere --function last_history_item

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

if status is-interactive
    atuin init fish | source
end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/fox/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
