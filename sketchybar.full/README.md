# SketchyBar Config

This repository is my personal configuration for [SketchyBar](https://github.com/FelixKratz/SketchyBar), a macOS plugin to customize the top menu bar.
My configuration is largely derived from and built upon [this repository](https://github.com/FelixKratz/dotfiles).

- I have two versions that I go back and forth between:

=== The Lua Configuration Version ===

![SketchyBar Config Appearance (Lua)](https://github.com/moonlinx/dotfiles/blob/main/screenshots/nowindow@2x.png?raw=true)

- This resides here: [branch.lua](https://github.com/moonlinx/dotfiles/tree/0216622f385348725818f8ca742a41b4be7434e8/sketchybar)

=== The Shell Configuration Version ===

![SketchyBar Config Appearance (Shell)](https://github.com/user-attachments/assets/db4d5e7d-1507-4958-a854-f034c7672a5f)

- This resides here: [branch.sh](https://github.com/moonlinx/dotfiles/tree/736bcadc098b973124ede8856b81dc9ef379cff4/sketchybar)

## Notable Enhancements

In addition to possessing all the features of the aforementioned configuration, this also offers the following improvements:

- New **Apple Menu** that gives _YOU_ the option as to what you want in your menu.
- **Zen Mode** to hide or display system information and remove unnecessary
  information for less distractions.
- New Search to pull up your app searcher of choice.
- **Battery Health** information, displayed when the Battery Widget is clicked.
- Redesigned **Calendar Widget** that opens Calendar when clicked.
- Improved **Media Widget**, with superior play/pause functionality.
- **VPN Icon** that displays on the **Wifi Widget**, when a connected to a VPN.

## Installation

1. Install [Homebrew](https://brew.sh/).

2. Install [Luarocks](https://luarocks.org/):

```bash
brew install luarocks
```

3. Install [Luajson](https://github.com/grafi-tt/lunajson):

```bash
sudo luarocks install lunajson
```

4. Run the following script, sourced from [this repository](https://github.com/FelixKratz/dotfiles):

```bash
curl -L https://raw.githubusercontent.com/FelixKratz/dotfiles/master/install_sketchybar.sh | sh
```

5. Run the following command to clone this repository and have it overwrite the SketchyBar configuration:

```bash
git clone https://github.com/moonlinx/dotfiles.git
```

6. Restart SketchyBar:

```bash
brew services restart sketchybar
```

> [!IMPORTANT]
> If something doesn't work, please let me know and I will fix and update!

Credits go to the followingfor their awesome configs that I just took, tweaked,
and modified ;)

- [The OG - FelixKratx](https://github.com/FelixKratz/SketchyBar) - For creating
  this masterpiece
- [waytoabv](https://github.com/waytoabv/Dotfiles) - For the wonderful layout
  ideas and yabai integration
- [john-json](https://github.com/john-json/Ilstr01-sketchybar) - For the
  beautiful apple menu and animations
