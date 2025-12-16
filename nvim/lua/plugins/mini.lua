-- -- git config is slowing mini.files too much, so disabling it
local mini_files_git = require("config.modules.mini-files-git")

return {
  {
    "nvim-mini/mini.files",
    enabled = true,
    opts = {
      -- I didn't like the default mappings, so I modified them
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        -- Use this if you want to open several files
        go_in = "l",
        -- This opens the file, but quits out of mini.files (default L)
        go_in_plus = "<CR>",
        -- I swapped the following 2 (default go_out: h)
        -- go_out_plus: when you go out, it shows you only 1 item to the right
        -- go_out: shows you all the items to the right
        go_out = "H",
        go_out_plus = "h",
        -- Default <BS>
        reset = "<BS>",
        -- Default @
        reveal_cwd = ".",
        show_help = "g?",
        -- Default =
        synchronize = "s",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 80,
      },
      options = {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = true,
        -- If set to false, files are moved to the trash directory
        -- To get this dir run :echo stdpath('data')
        -- ~/.local/share/neobean/mini.files/trash
        permanent_delete = false,
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      custom_keymaps = {
        copy_to_clipboard = "<space>yy",
        zip_and_copy = "<space>yz",
        paste_from_clipboard = "<space>p",
        -- Don't use "i" as it conflicts wit insert mode
        preview_image = "<space>i",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    config = function(_, opts)
      -- Set up mini.files
      require("mini.files").setup(opts)
      -- Load Git integration
      -- git config is slowing mini.files too much, so disabling it
      mini_files_git.setup()
    end,
  },

  -- Surround
  -- {
  --   "nvim-mini/mini.surround",
  --   event = { "BufReadPre", "BufNewFile" },
  --   enabled = false,
  --   opts = {
  --     -- Add custom surroundings to be used on top of builtin ones. For more
  --     -- information with examples, see `:h MiniSurround.config`.
  --     custom_surroundings = nil,
  --
  --     -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  --     highlight_duration = 300,
  --
  --     -- Module mappings. Use `''` (empty string) to disable one.
  --     -- INFO:
  --     -- saiw surround with no whitespace
  --     -- saw surround with whitespace
  --     mappings = {
  --       add = "sa", -- Add surrounding in Normal and Visual modes
  --       delete = "ds", -- Delete surrounding
  --       find = "sf", -- Find surrounding (to the right)
  --       find_left = "sF", -- Find surrounding (to the left)
  --       highlight = "sh", -- Highliglt surrounding
  --       replace = "sr", -- Replace surrounding
  --       update_n_lines = "sn", -- Update `n_lines`
  --
  --       suffix_last = "l", -- Suffix to searcl with "prev" method
  --       suffix_next = "n", -- Suffix to search with "next" method
  --     },
  --
  --     -- Number of lines within which surrounding is searched
  --     n_lines = 20,
  --
  --     -- Whether to respect selection type:
  --     -- - Place surroundings on separate lines in linewise mode.
  --     -- - Place surroundings on each line in blockwise mode.
  --     respect_selection_type = false,
  --
  --     -- How to search for surrounding (first inside current line, then inside
  --     -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  --     -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
  --     -- see `:h MiniSurround.config`.
  --     search_method = "cover",
  --
  --     -- Whether to disable showing non-error feedback
  --     silent = false,
  --   },
  -- },
  -- Cursorword
  {
    "nvim-mini/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup()
    end,
  },
}
