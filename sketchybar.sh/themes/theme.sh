## This is an example file for custom theme addition

# color format : 0x<hex value for transparency between 0-255><hex rgb color value>

# Catpuccin Mocha theme
if [[ "$COLOR_SCHEME" == "catppuccin-mocha" ]]; then
  # Default Theme colors
  export BASE=0xff1e1e2e
  export SURFACE=0xff6c7086
  export OVERLAY=0xff313244
  export MUTED=0xff6e6a86
  export SUBTLE=0xff908caa

  export TEXT=0xffcdd6f4
  export RED=0xfff38ba8
  export YELLOW=0xfff9e2af
  export GREEN=0xffa6e3a1
  export WARN=0xffeba0ac
  export BLUE=0xff89b4fa
  export GLOW=0xff89dceb
  export ACTIVE=0xffcba6f7

  export HIGH_LOW=0xff1e1e2e
  export HIGH_MED=0xff45475a
  export HIGH_HIGH=0xff585b70

  export BLACK=0xff11111b
  export TRANSPARENT=0x00000000

  # General bar colors
  if [[ $BAR_TRANSPARENCY == true ]]; then
    export BAR_COLOR=0xB81f2027
    export BORDER_COLOR=0xB845475a
  elif [[ $BAR_TRANSPARENCY == false ]]; then
    export BAR_COLOR=0xff1f1f30
    export BORDER_COLOR=0xff45475a
  fi
  export ICON_COLOR=$TEXT  # Color of all icons
  export LABEL_COLOR=$TEXT # Color of all labels

  export POPUP_BACKGROUND_COLOR=0xbe393552
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi

if [[ "$COLOR_SCHEME" == "kopicat" ]]; then
  # Default Theme colors
  export BASE=0xff1e1e2e
  export SURFACE=0xff6c7086
  export OVERLAY=0xff313244
  export MUTED=0xff6e6a86
  export SUBTLE=0xff908caa

  export TEXT=0xfffcfcfa
  export RED=0xfff38ba8
  export YELLOW=0xffCAA75E
  export WARN=0xffFF8459
  export SELECT=0xff89b4fa
  export GLOW=0xff87A35E
  export ACTIVE=0xff986794

  export HIGH_LOW=0xff1e1e2e
  export HIGH_MED=0xff45475a
  export HIGH_HIGH=0xff585b70

  export BLACK=0xff11111b
  export TRANSPARENT=0x00000000

  # General bar colors
  export BAR_COLOR=0x80313244 #0xD9232136
  export BORDER_COLOR=0x8045475a
  export ICON_COLOR=$TEXT  # Color of all icons
  export LABEL_COLOR=$TEXT # Color of all labels

  export POPUP_BACKGROUND_COLOR=0xbe393552
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi

if [[ "$COLOR_SCHEME" == "solarized_osaka" ]]; then
  # Solarized Osaka Theme colors - Enhanced for better contrast
  export BASE=0xff002b36
  export SURFACE=0xff073642
  export OVERLAY=0xff586e75
  export MUTED=0xff657b83
  export SUBTLE=0xff839496

  export TEXT=0xffeee8d5
  export RED=0xffdc322f
  export YELLOW=0xffb58900
  export GREEN=0xff859900
  export WARN=0xffd33682
  export BLUE=0xff268bd2
  export GLOW=0xff2aa198
  export ACTIVE=0xff6c71c4

  export HIGH_LOW=0xff002b36
  export HIGH_MED=0xff073642
  export HIGH_HIGH=0xff0f3b47

  export BLACK=0xff00141a
  export TRANSPARENT=0x00000000

  # General bar colors
  if [[ $BAR_TRANSPARENCY == true ]]; then
    export BAR_COLOR=0xB8073642
    export BORDER_COLOR=0xB8586e75
  elif [[ $BAR_TRANSPARENCY == false ]]; then
    export BAR_COLOR=0xff002b36
    export BORDER_COLOR=0xff073642
  fi
  export ICON_COLOR=$TEXT
  export LABEL_COLOR=$TEXT

  export POPUP_BACKGROUND_COLOR=0xbe073642
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi

if [[ "$COLOR_SCHEME" == "kanagawa" ]]; then
  # Kanagawa Theme colors - Enhanced for better contrast
  export BASE=0xff2a2a37
  export SURFACE=0xff363646
  export OVERLAY=0xff585873
  export MUTED=0xff72727f
  export SUBTLE=0xff8c8c8c

  export TEXT=0xffd5d0ba
  export RED=0xffc34043
  export YELLOW=0xffe6c384
  export GREEN=0xff76946a
  export WARN=0xffd27e99
  export BLUE=0xff7e9cd8
  export GLOW=0xff6a9589
  export ACTIVE=0xffd67cc8

  export HIGH_LOW=0xff2a2a37
  export HIGH_MED=0xff363646
  export HIGH_HIGH=0xff414156

  export BLACK=0xff16161d
  export TRANSPARENT=0x00000000

  # General bar colors
  if [[ $BAR_TRANSPARENCY == true ]]; then
    export BAR_COLOR=0xB8363646
    export BORDER_COLOR=0xB8585873
  elif [[ $BAR_TRANSPARENCY == false ]]; then
    export BAR_COLOR=0xff2a2a37
    export BORDER_COLOR=0xff363646
  fi
  export ICON_COLOR=$TEXT
  export LABEL_COLOR=$TEXT

  export POPUP_BACKGROUND_COLOR=0xbe363646
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi

if [[ "$COLOR_SCHEME" == "tokyo_night" ]]; then
  # Tokyo Night Theme colors - Enhanced for better contrast
  export BASE=0xff1a1b26
  export SURFACE=0xff292e42
  export OVERLAY=0xff414868
  export MUTED=0xff3b4261
  export SUBTLE=0xff565f89

  export TEXT=0xffc0caf5
  export RED=0xfff7768e
  export YELLOW=0xffffb86c
  export GREEN=0xff9ece6a
  export WARN=0xff7aa2f7
  export BLUE=0xff7aa2f7
  export GLOW=0xff7dcfff
  export ACTIVE=0xffbb9af7

  export HIGH_LOW=0xff1a1b26
  export HIGH_MED=0xff292e42
  export HIGH_HIGH=0xff3b4261

  export BLACK=0xff0f0f14
  export TRANSPARENT=0x00000000

  # General bar colors
  if [[ $BAR_TRANSPARENCY == true ]]; then
    export BAR_COLOR=0xB8292e42
    export BORDER_COLOR=0xB8414868
  elif [[ $BAR_TRANSPARENCY == false ]]; then
    export BAR_COLOR=0xff1a1b26
    export BORDER_COLOR=0xff292e42
  fi
  export ICON_COLOR=$TEXT
  export LABEL_COLOR=$TEXT

  export POPUP_BACKGROUND_COLOR=0xbe292e42
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi

if [[ "$COLOR_SCHEME" == "catppuccin-frappe" ]]; then
  # Catppuccin Frappe Theme
  export BASE=0xff303446
  export SURFACE=0xff414559
  export OVERLAY=0xff51576d
  export MUTED=0xff737994
  export SUBTLE=0xff949cbb

  export TEXT=0xffc6d0f5
  export RED=0xffe78284
  export YELLOW=0xffe5c890
  export GREEN=0xffa6d189
  export WARN=0xfff4b8e4
  export BLUE=0xff8caaee
  export GLOW=0xff81c8be
  export ACTIVE=0xffca9ee6

  export HIGH_LOW=0xff303446
  export HIGH_MED=0xff414559
  export HIGH_HIGH=0xff51576d

  export BLACK=0xff232634
  export TRANSPARENT=0x00000000

  # General bar colors
  if [[ $BAR_TRANSPARENCY == true ]]; then
    export BAR_COLOR=0xB8414559
    export BORDER_COLOR=0xB851576d
  elif [[ $BAR_TRANSPARENCY == false ]]; then
    export BAR_COLOR=0xff303446
    export BORDER_COLOR=0xff414559
  fi
  export ICON_COLOR=$TEXT
  export LABEL_COLOR=$TEXT

  export POPUP_BACKGROUND_COLOR=0xbe414559
  export POPUP_BORDER_COLOR=$HIGH_MED

  export SHADOW_COLOR=$TEXT
fi
