return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  enabled = false,
  opts = {
    html = {
      enable = true,
    },
    markdown = {
      enable = true,
      block_quotes = {
        enable = true,
        wrap = true,

        default = {
          border = "▋",
          hl = "MarkviewBlockQuoteDefault",
        },

        ["ABSTRACT"] = {
          preview = "󱉫 Abstract",
          hl = "MarkviewBlockQuoteNote",

          title = true,
          icon = "󱉫",
        },
        ["SUMMARY"] = {
          hl = "MarkviewBlockQuoteNote",
          preview = "󱉫 Summary",

          title = true,
          icon = "󱉫",
        },
        ["TLDR"] = {
          hl = "MarkviewBlockQuoteNote",
          preview = "󱉫 Tldr",

          title = true,
          icon = "󱉫",
        },
        ["TODO"] = {
          hl = "MarkviewBlockQuoteNote",
          preview = " Todo",

          title = true,
          icon = "",
        },
        ["INFO"] = {
          hl = "MarkviewBlockQuoteNote",
          preview = " Info",

          custom_title = true,
          icon = "",
        },
        ["SUCCESS"] = {
          hl = "MarkviewBlockQuoteOk",
          preview = "󰗠 Success",

          title = true,
          icon = "󰗠",
        },
        ["CHECK"] = {
          hl = "MarkviewBlockQuoteOk",
          preview = "󰗠 Check",

          title = true,
          icon = "󰗠",
        },
        ["DONE"] = {
          hl = "MarkviewBlockQuoteOk",
          preview = "󰗠 Done",

          title = true,
          icon = "󰗠",
        },
        ["QUESTION"] = {
          hl = "MarkviewBlockQuoteWarn",
          preview = "󰋗 Question",

          title = true,
          icon = "󰋗",
        },
        ["HELP"] = {
          hl = "MarkviewBlockQuoteWarn",
          preview = "󰋗 Help",

          title = true,
          icon = "󰋗",
        },
        ["FAQ"] = {
          hl = "MarkviewBlockQuoteWarn",
          preview = "󰋗 Faq",

          title = true,
          icon = "󰋗",
        },
        ["FAILURE"] = {
          hl = "MarkviewBlockQuoteError",
          preview = "󰅙 Failure",

          title = true,
          icon = "󰅙",
        },
        ["FAIL"] = {
          hl = "MarkviewBlockQuoteError",
          preview = "󰅙 Fail",

          title = true,
          icon = "󰅙",
        },
        ["MISSING"] = {
          hl = "MarkviewBlockQuoteError",
          preview = "󰅙 Missing",

          title = true,
          icon = "󰅙",
        },
        ["DANGER"] = {
          hl = "MarkviewBlockQuoteError",
          preview = " Danger",

          title = true,
          icon = "",
        },
        ["ERROR"] = {
          hl = "MarkviewBlockQuoteError",
          preview = " Error",

          title = true,
          icon = "",
        },
        ["BUG"] = {
          hl = "MarkviewBlockQuoteError",
          preview = " Bug",

          title = true,
          icon = "",
        },
        ["EXAMPLE"] = {
          hl = "MarkviewBlockQuoteSpecial",
          preview = "󱖫 Example",

          title = true,
          icon = "󱖫",
        },
        ["QUOTE"] = {
          hl = "MarkviewBlockQuoteDefault",
          preview = " Quote",

          title = true,
          icon = "",
        },
        ["CITE"] = {
          hl = "MarkviewBlockQuoteDefault",
          preview = " Cite",

          title = true,
          icon = "",
        },
        ["HINT"] = {
          hl = "MarkviewBlockQuoteOk",
          preview = " Hint",

          title = true,
          icon = "",
        },
        ["ATTENTION"] = {
          hl = "MarkviewBlockQuoteWarn",
          preview = " Attention",

          title = true,
          icon = "",
        },

        ["NOTE"] = {
          hl = "MarkviewBlockQuoteNote",
          preview = "󰋽 Note",

          title = true,
          icon = "󰋽",
        },
        ["TIP"] = {
          hl = "MarkviewBlockQuoteOk",
          preview = " Tip",

          title = true,
          icon = "",
        },
        ["IMPORTANT"] = {
          hl = "MarkviewBlockQuoteSpecial",
          preview = " Important",

          title = true,
          icon = "",
        },
        ["WARNING"] = {
          hl = "MarkviewBlockQuoteWarn",
          preview = " Warning",

          title = true,
          icon = "",
        },
        ["CAUTION"] = {
          hl = "MarkviewBlockQuoteError",
          preview = "󰳦 Caution",

          title = true,
          icon = "󰳦",
        },
      },
      reference_definitions = {
        enable = true,

        default = {
          icon = " ",
          hl = "MarkviewPalette4Fg",
        },

        ["github%.com/[%a%d%-%_%.]+%/?$"] = {
          --- github.com/<user>

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
          --- github.com/<user>/<repo>

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
          --- github.com/<user>/<repo>/tree/<branch>

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
          --- github.com/<user>/<repo>/commits/<branch>

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },

        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
          --- github.com/<user>/<repo>/releases

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
          --- github.com/<user>/<repo>/tags

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
          --- github.com/<user>/<repo>/issues

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
          --- github.com/<user>/<repo>/pulls

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },

        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
          --- github.com/<user>/<repo>/wiki

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },

        ["developer%.mozilla%.org"] = {
          priority = -9999,

          icon = "󰖟 ",
          hl = "MarkviewPalette5Fg",
        },

        ["w3schools%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette4Fg",
        },

        ["stackoverflow%.com"] = {
          priority = -9999,

          icon = "󰓌 ",
          hl = "MarkviewPalette2Fg",
        },

        ["reddit%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette2Fg",
        },

        ["github%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette6Fg",
        },

        ["gitlab%.com"] = {
          priority = -9999,

          icon = "󰮠 ",
          hl = "MarkviewPalette2Fg",
        },

        ["dev%.to"] = {
          priority = -9999,

          icon = "󱁴 ",
          hl = "MarkviewPalette0Fg",
        },

        ["codepen%.io"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette6Fg",
        },

        ["replit%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette2Fg",
        },

        ["jsfiddle%.net"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette5Fg",
        },

        ["npmjs%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette0Fg",
        },

        ["pypi%.org"] = {
          priority = -9999,

          icon = "󰆦 ",
          hl = "MarkviewPalette0Fg",
        },

        ["mvnrepository%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette1Fg",
        },

        ["medium%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette6Fg",
        },

        ["linkedin%.com"] = {
          priority = -9999,

          icon = "󰌻 ",
          hl = "MarkviewPalette5Fg",
        },

        ["news%.ycombinator%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette2Fg",
        },
        ["youtube[^.]*%.com"] = {
          priority = -9999,

          icon = "󰗃 ",
          hl = "MarkviewPalette1Fg",
        },
        ["x%.com"] = {
          priority = -9999,

          icon = " ",
          hl = "MarkviewPalette5Fg",
        },
        ["google%.com"] = {
          priority = -9999,

          icon = "󰊭 ",
          hl = "MarkviewPalette0Fg",
        },
      },
      tables = {
        enable = true,
        strict = falsej,

        block_decorator = true,
        use_virt_lines = false,

        parts = {
          top = { "╭", "─", "╮", "┬" },
          header = { "│", "│", "│" },
          separator = { "├", "─", "┤", "┼" },
          row = { "│", "│", "│" },
          bottom = { "╰", "─", "╯", "┴" },

          overlap = { "┝", "━", "┥", "┿" },

          align_left = "╼",
          align_right = "╾",
          align_center = { "╴", "╶" },
        },

        hl = {
          top = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
          header = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
          separator = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
          row = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
          bottom = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },

          overlap = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },

          align_left = "MarkviewTableAlignLeft",
          align_right = "MarkviewTableAlignRight",
          align_center = { "MarkviewTableAlignCenter", "MarkviewTableAlignCenter" },
        },
      },
    },
    preview = {
      callbacks = {
        ---+${func}

        on_attach = function(_, wins)
          ---+${lua}

          --- Initial state for attached buffers.
          ---@type string
          local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true })

          if attach_state == false then
            --- Attached buffers will not have their previews
            --- enabled.
            --- So, don't set options.
            return
          end

          for _, win in ipairs(wins) do
            --- Preferred conceal level should
            --- be 3.
            vim.wo[win].conceallevel = 3
          end

          ---_
        end,

        on_detach = function(_, wins)
          ---+${lua}
          for _, win in ipairs(wins) do
            --- Only set `conceallevel`.
            --- `concealcursor` will be
            --- set via `on_hybrid_disable`.
            vim.wo[win].conceallevel = 0
          end
          ---_
        end,

        on_enable = function(_, wins)
          ---+${lua}

          for _, win in ipairs(wins) do
            vim.wo[win].conceallevel = 3
          end

          ---_
        end,

        on_disable = function(_, wins)
          ---+${lua}
          for _, win in ipairs(wins) do
            vim.wo[win].conceallevel = 0
          end
          ---_
        end,

        on_hybrid_enable = function(_, wins)
          ---+${lua}

          ---@type string[]
          local prev_modes = spec.get({ "preview", "modes" }, { fallback = {} })
          ---@type string[]
          local hybd_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {} })

          local concealcursor = ""

          for _, mode in ipairs(prev_modes) do
            if vim.list_contains(hybd_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
              concealcursor = concealcursor .. mode
            end
          end

          for _, win in ipairs(wins) do
            vim.wo[win].concealcursor = concealcursor
          end

          ---_
        end,

        on_hybrid_disable = function(_, wins)
          ---+${lua}

          ---@type string[]
          local prev_modes = spec.get({ "preview", "modes" }, { fallback = {} })
          local concealcursor = ""

          for _, mode in ipairs(prev_modes) do
            if vim.list_contains({ "n", "v", "i", "c" }, mode) then
              concealcursor = concealcursor .. mode
            end
          end

          for _, win in ipairs(wins) do
            vim.wo[win].concealcursor = concealcursor
          end

          ---_
        end,

        on_mode_change = function(_, wins, current_mode)
          ---+${lua}

          ---@type string[]
          local preview_modes = spec.get({ "preview", "modes" }, { fallback = {} })
          ---@type string[]
          local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {} })

          local concealcursor = ""

          for _, mode in ipairs(preview_modes) do
            if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
              concealcursor = concealcursor .. mode
            end
          end

          for _, win in ipairs(wins) do
            if vim.list_contains(preview_modes, current_mode) then
              vim.wo[win].conceallevel = 3
              vim.wo[win].concealcursor = concealcursor
            else
              vim.wo[win].conceallevel = 0
              vim.wo[win].concealcursor = ""
            end
          end
          ---_
        end,

        on_splitview_open = function(_, _, win)
          ---+${lua}
          vim.wo[win].conceallevel = 3
          vim.wo[win].concealcursor = "n"
          ---_
        end,
        ---_
      },
      debounce = 150,
      icon_provider = "internal",
      draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
      edit_range = { 0, 0 },
      modes = { "n", "no", "c" },
      hybrid_modes = {},
      linewise_hybrid_mode = false,
      max_buf_lines = 1000,
      filetypes = { "markdown", "quarto", "rmd", "typst" },
      ignore_buftypes = { "nofile" },
      ignore_previews = {},
      splitview_winopts = {
        split = "right",
      },
    },
  },
}
