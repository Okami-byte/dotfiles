local mod = {}

local tpf_mask = 0x1000000

local function colorTp(base_color, tpf)
  if tpf < 0 then tpf = 0
  elseif tpf > 255 then tpf = 255
  end
  return base_color + tpf * tpf_mask
end

local function resolvePalette(p, tpf)
  local t = {}
  for k, v in pairs(p) do
    if type(v) == "table" then
      t[k] = resolvePalette(v, tpf)
    elseif type(v) == "function" then
      t[k] = v(tpf, colorTp)
    else
      t[k] = v
    end
  end
  return t
end

local palettes = {
  ["rose_pine"] = {
    bar = {
      background = function(tpf, f) return f(0x161616, 145) end,
      border     = function(tpf, f) return f(0x808080, tpf - 20) end,
    },
    text = {
      primary = 0xffe0def4,
      subtle  = 0xff908caa,
      muted   = 0xff6e6a86,
    },
    zone = {
      background = function(tpf, f) return f(0x393552, tpf - 50) end,
      border     = function(tpf, f) return f(0x44415a, tpf - 20) end,
      overlay    = 0xff56526e,
    },
    colors = {
      red    = 0xffeb6f92,
      orange = 0xffea9a97,
      yellow = 0xfff6c177,
      blue   = 0xff3e8fb0,
      cyan   = 0xff9ccfd8,
      purple = 0xffc4a7e7,
      black  = 0xff000000,
    },
  },

  ["catppuccin_mocha"] = {
    bar = {
      background = function(tpf, f) return f(0x1f2027, tpf) end,
      border     = function(tpf, f) return f(0x45475a, tpf) end,
    },
    text = {
      primary = 0xffcdd6f4,
      subtle  = 0xff908caa,
      muted   = 0xff6e6a86,
    },
    zone = {
      background = function(tpf, f) return f(0x313244, tpf - 50) end,
      border     = function(tpf, f) return f(0x45475a, tpf - 20) end,
      overlay    = 0xff585b70,
    },
    colors = {
      red    = 0xfff38ba8,
      orange = 0xffeba0ac,
      yellow = 0xfff9e2af,
      blue   = 0xff89b4fa,
      cyan   = 0xff89dceb,
      purple = 0xffcba6f7,
      black  = 0xff11111b,
    },
  },

  ["catppuccin_frappe"] = {
    bar = {
      background = function(tpf, f) return f(0x414559, tpf) end,
      border     = function(tpf, f) return f(0x51576d, tpf) end,
    },
    text = {
      primary = 0xffc6d0f5,
      subtle  = 0xff949cbb,
      muted   = 0xff737994,
    },
    zone = {
      background = function(tpf, f) return f(0x51576d, tpf - 50) end,
      border     = function(tpf, f) return f(0x414559, tpf - 20) end,
      overlay    = 0xff51576d,
    },
    colors = {
      red    = 0xffe78284,
      orange = 0xfff4b8e4,
      yellow = 0xffe5c890,
      blue   = 0xff8caaee,
      cyan   = 0xff81c8be,
      purple = 0xffca9ee6,
      black  = 0xff232634,
    },
  },

  ["kanagawa"] = {
    bar = {
      background = function(tpf, f) return f(0x363646, tpf) end,
      border     = function(tpf, f) return f(0x585873, tpf) end,
    },
    text = {
      primary = 0xffd5d0ba,
      subtle  = 0xff8c8c8c,
      muted   = 0xff72727f,
    },
    zone = {
      background = function(tpf, f) return f(0x585873, tpf - 50) end,
      border     = function(tpf, f) return f(0x363646, tpf - 20) end,
      overlay    = 0xff414156,
    },
    colors = {
      red    = 0xffc34043,
      orange = 0xffd27e99,
      yellow = 0xffe6c384,
      blue   = 0xff7e9cd8,
      cyan   = 0xff6a9589,
      purple = 0xffd67cc8,
      black  = 0xff16161d,
    },
  },

  ["tokyo_night"] = {
    bar = {
      background = function(tpf, f) return f(0x292e42, tpf) end,
      border     = function(tpf, f) return f(0x414868, tpf) end,
    },
    text = {
      primary = 0xffc0caf5,
      subtle  = 0xff565f89,
      muted   = 0xff3b4261,
    },
    zone = {
      background = function(tpf, f) return f(0x414868, tpf - 50) end,
      border     = function(tpf, f) return f(0x292e42, tpf - 20) end,
      overlay    = 0xff3b4261,
    },
    colors = {
      red    = 0xfff7768e,
      orange = 0xffffb86c,
      yellow = 0xffffb86c,
      blue   = 0xff7aa2f7,
      cyan   = 0xff7dcfff,
      purple = 0xffbb9af7,
      black  = 0xff0f0f14,
    },
  },

  ["solarized_osaka"] = {
    bar = {
      background = function(tpf, f) return f(0x073642, tpf) end,
      border     = function(tpf, f) return f(0x586e75, tpf) end,
    },
    text = {
      primary = 0xffeee8d5,
      subtle  = 0xff839496,
      muted   = 0xff657b83,
    },
    zone = {
      background = function(tpf, f) return f(0x586e75, tpf - 50) end,
      border     = function(tpf, f) return f(0x073642, tpf - 20) end,
      overlay    = 0xff0f3b47,
    },
    colors = {
      red    = 0xffdc322f,
      orange = 0xffd33682,
      yellow = 0xffb58900,
      blue   = 0xff268bd2,
      cyan   = 0xff2aa198,
      purple = 0xff6c71c4,
      black  = 0xff00141a,
    },
  },
}

local function fetchCustomPalette(palettes)
  local custom_palettes = {}
  local palette_file, err = loadfile(config.theme_file, "t", palettes)
  if palette_file then
    palette_file()
    mergeTables(palettes, custom_palettes, false)
  else
    log("lua-main", "No custom palette loaded: " .. err)
  end
end

function mod.getColorPalette(name, base_tpf)
  fetchCustomPalette(palettes)
  local palette = palettes[name]
  if not palette then
    error("Unknown palette: " .. name)
  end
  return resolvePalette(palette, base_tpf)
end

return mod
