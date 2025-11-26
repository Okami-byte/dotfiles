#  █████╗ ██████╗ ██████╗ ██████╗
# ██╔══██╗██╔══██╗██╔══██╗██╔══██╗
# ███████║██████╔╝██████╔╝██████╔╝
# ██╔══██║██╔══██╗██╔══██╗██╔══██╗
# ██║  ██║██████╔╝██████╔╝██║  ██║
# ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝
# abbreviations - user-defined words that are replaced with longer phrases when entered
# https://fishshell.com/docs/current/cmds/abbr.html
# cSpell:disable

# Brew
abbr bu "brew update"
abbr bug "brew upgrade"
abbr bo "brew outdated"
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bin "brew info"
abbr binc "brew info --cask"
abbr bl "brew leaves"
abbr blr "brew leaves --installed-on-request"
abbr blp "brew leaves --installed-as-dependency"
abbr bs "brew search"

# Espanso
abbr ee "espanso edit"
abbr er "espanso restart"

# Git abbreviations.
abbr -a g git
abbr -a ga git add -A
abbr -a gp git push
abbr -a gpl git pull
abbr -a gcl git clone
abbr -a gb git branch
abbr -a gcm git commit -m ""
abbr -a gco git checkout
abbr -a gf git fetch
abbr -a gl lazygit
abbr -a gm git merge
abbr -a gst git status --short
abbr -a glo serie

# LazyDocker
abbr -a ld lazydocker

# LazyGit
abbr -a lg lazygit

# Miscellaneous
abbr d delta
# abbr ff fastfetch

abbr fi "fisher install"
abbr fr "fisher refresh"
abbr fu "fisher update"

abbr gn "sudo shutdown -h now"
abbr nm "nmap -sC -sV -oN nmap-output.txt"
abbr sp spotify_player
abbr wifi wifi-password
abbr x exit
abbr ya yazi
abbr yt yt-dlp
abbr z zoxide

# Neovim.
abbr -a nv nvim
abbr -a nvp nvim +Man!

# Sesh
abbr s sesh_start
abbr s. "sesh connect ."
abbr sc "sesh clone --cmdDir ~/c (pbpaste)"
abbr sf "source ~/.config/fish/config.fish"
abbr sr "sesh root"

# Tmux
abbr tn "tmux new-session -s"
abbr tl "tmux list-sessions"
abbr ta "tmux attach-session"
