![mr-fox-dotfiles](https://github.com/user-attachments/assets/5d1a16c9-8c86-45f3-9917-6b3d2d3ba7ae)

# .dotfiles

## Contents

### Table of contents

<!-- toc -->

- [Overview](#overview)
- [Installation](#installation)
  * [Homebrew installation](#homebrew-installation)
  * [Customization](#customization)
    + [Git](#git)
    + [Color Schemes](#color-schemes)
- [Acknowledgements](#acknowledgements)

<!-- tocstop -->

## Overview

Dotfiles for my M3 Max Macbook Pro: Running macOS Sonoma 15.2.

- **Terminal** : [Wezterm](https://github.com/wez/wezterm) using fish w/ [starship prompt](https://github.com/starship/starship) and [eza](https://github.com/eza-community/eza)
- **Window Management** : [yabai](https://github.com/koekeishiya/yabai) and [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- **Launcher**: [Raycast](https://www.raycast.com)
- **Bar** : [Sketchybar](https://github.com/FelixKratz/SketchyBar)
- **File Management** : [yazi](https://github.com/sxyazi/yazi)
- **Hotkeys** : [skhd](https://github.com/koekeishiya/skhd)
- **Vim** : [neovim](https://neovim.io) / [lazyvim](https://github.com/LazyVim/LazyVim) to manage plugins
- **Tools** : [tmux](https://github.com/tmux/tmux), [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf)
- **Browser**: [Zen-Browser](https://zen-browser.app/)

## Installation

**Before you get started** make sure you give full disk access (test) permission to your terminal (for writing macos defaults). `System Preferences -> Privacy -> Full Disk Access`.


```bash
bash -c "$(curl -LsS https://raw.githubusercontent.com/Okami-byte/dotfiles/refs/heads/main/install.sh)"
```

### Customization

#### Git

- Be sure to update the user name/email values in the global [gitconfig](./git/.gitconfig)

#### Color Schemes

- Wezterm color scheme is [Catppuccin - Machiatto](https://github.com/catppuccin/wezterm)
- Neovim color scheme is [Catppuccin - Mocha](https://github.com/catppuccin/wezterm)

## Acknowledgements

- [huyvohcmc/dotfiles](https://github.com/huyvohcmc/dotfiles)
- [alrra/dotfiles](https://github.com/alrra/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [gretzky/dotfiles](https://github.com/gretzky/dotfiles)
- [waytoabv/dotfiles](https://github.com/waytoabv/Dotfiles)
- [Kcraft059/dotfiles](https://github.com/Kcraft059/sketchybar-config/?tab=readme-ov-file)
