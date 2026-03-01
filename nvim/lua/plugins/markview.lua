return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  enabled = false,
  opts = {
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
