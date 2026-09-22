return {
  "saghen/blink.cmp",
  enabled = true,
  version = "v1.*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
  },
  opts = function(_, opts)
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      fuzzy = {
        implementation = "prefer_rust",
      },
      default = {
        "lsp",
        "path",
        "buffer",
        "snippets",
        "ripgrep",
      },
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 0,
          score_offset = 90, -- the higher the number, the higher the priority
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          -- When typing a path, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no path
          -- suggestions
          fallbacks = { "luasnip", "buffer" },
          -- min_keyword_length = 2,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },

        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 4,
          score_offset = 15, -- the higher the number, the higher the priority
        },

        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85, -- the higher the number, the higher the priority
        },

        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          -- the options below are optional, some default values are shown
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            -- the minimum length of the current word to start searching
            -- (if the word is shorter than this, the search will not start)
            prefix_min_len = 3,

            -- Specifies how to find the root of the project where the ripgrep
            -- search will start from. Accepts the same options as the marker
            -- given to `:h vim.fs.root()` which offers many possibilities for
            -- configuration. If none can be found, defaults to Neovim's cwd.
            --
            -- Examples:
            -- - ".git" (default)
            -- - { ".git", "package.json", ".root" }
            project_root_marker = ".git",

            -- When a result is found for a file whose filetype does not have a
            -- treesitter parser installed, fall back to regex based highlighting
            -- that is bundled in Neovim.
            fallback_to_regex_highlighting = true,

            -- Keymaps to toggle features on/off. This can be used to alter
            -- the behavior of the plugin without restarting Neovim. Nothing
            -- is enabled by default. Requires folke/snacks.nvim.
            toggles = {
              -- The keymap to toggle the plugin on and off from blink
              -- completion results. Example: "<leader>tg" ("toggle grep")
              on_off = nil,

              -- The keymap to toggle debug mode on/off. Example: "<leader>td" ("toggle debug")
              debug = nil,
            },

            backend = {
              -- The backend to use for searching. Defaults to "ripgrep".
              use = "ripgrep",

              -- Whether to set up custom highlight-groups for the icons used
              -- in the completion items. Defaults to `true`, which means this
              -- is enabled.
              customize_icon_highlight = true,

              ripgrep = {
                -- For many options, see `rg --help` for an exact description of
                -- the values that ripgrep expects.

                -- The number of lines to show around each match in the preview
                -- (documentation) window. For example, 5 means to show 5 lines
                -- before, then the match, and another 5 lines after the match.
                context_size = 5,

                -- The maximum file size of a file that ripgrep should include
                -- in its search. Useful when your project contains large files
                -- that might cause performance issues.
                -- Examples:
                -- "1024" (bytes by default), "200K", "1M", "1G", which will
                -- exclude files larger than that size.
                max_filesize = "1M",

                -- Enable fallback to neovim cwd if project_root_marker is not
                -- found. Default: `true`, which means to use the cwd.
                project_root_fallback = true,

                -- The casing to use for the search in a format that ripgrep
                -- accepts. Defaults to "--ignore-case". See `rg --help` for
                -- all the available options ripgrep supports, but you can try
                -- "--case-sensitive" or "--smart-case".
                search_casing = "--ignore-case",

                -- (advanced) Any additional options you want to give to
                -- ripgrep. See `rg -h` for a list of all available options.
                -- Might be helpful in adjusting performance in specific
                -- situations. If you have an idea for a default, please open
                -- an issue!
                --
                -- Not everything will work (obviously).
                additional_rg_options = {},

                -- Absolute root paths where the rg command will not be
                -- executed. Usually you want to exclude paths using gitignore
                -- files or ripgrep specific ignore files, but this can be used
                -- to only ignore the paths in blink-ripgrep.nvim, maintaining
                -- the ability to use ripgrep for those paths on the command
                -- line. If you need to find out where the searches are
                -- executed, enable `debug` and look at `:messages`.
                ignore_paths = {},

                -- Any additional paths to search in, in addition to the
                -- project root. This can be useful if you want to include
                -- dictionary files (/usr/share/dict/words), framework
                -- documentation, or any other reference material that is not
                -- available within the project root.
                additional_paths = {},
              },
            },

            -- Show debug information in `:messages` that can help in
            -- diagnosing issues with the plugin.
            debug = false,
          },
          -- (optional) customize how the results are displayed. Many options
          -- are available - make sure your lua LSP is set up so you get
          -- autocompletion help
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              -- example: append a description to easily distinguish rg results
              item.labelDetails = {
                description = "(rg)",
              }
            end
            return items
          end,
        },
      },
    })
    opts.cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      completion = {
        menu = { auto_show = true },
      },
    }

    opts.completion = {
      --   keyword = {
      --     -- 'prefix' will fuzzy match on the text before the cursor
      --     -- 'full' will fuzzy match on the text before *and* after the cursor
      --     -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      --     range = "full",
      --   },
      menu = {
        border = "rounded",
        max_height = 15,
        scrolloff = 0,
        draw = {
          gap = 2,
          -- align_to = "cursor",
          -- padding = 0,
          columns = {
            -- { "kind_icon" },
            -- { "label", "label_description", gap = 1 },
            -- { "source_name" },
            { "source_name", gap = 1 },
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 2 },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        update_delay_ms = 100,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
      -- Displays a preview of the selected item on the current line
      -- ghost_text = {
      --   enabled = true,
      -- },
    }

    -- opts.fuzzy = {
    --   -- Disabling this matches the behavior of fzf
    --   use_typo_resistance = false,
    --   -- Frecency tracks the most recently/frequently used items and boosts the score of the item
    --   use_frecency = true,
    --   -- Proximity bonus boosts the score of items matching nearby words
    --   use_proximity = false,
    -- }

    opts.snippets = {
      preset = "luasnip",
    }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    opts.keymap = {
      preset = "none",
      ["<C-\\>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-c>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "show" },

      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },

      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    }

    return opts
  end,

  -- Experimental signature help support
  signature = {
    enabled = true,
    window = {
      border = "rounded",
    },
  },
}
