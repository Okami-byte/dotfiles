return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    -- used for the "snacks" picker (list UI) and "delta" backend preview
    -- (rendered via Snacks.terminal)
    { "folke/snacks.nvim" },
  },
  event = "LspAttach",
  opts = {
    --- The backend to use, currently only "vim", "delta", "difftastic", "diffsofancy" are supported
    backend = "delta",

    -- The picker to use, "telescope", "snacks", "select", "buffer" are supported
    -- And it's opts that will be passed at the picker's creation, optional
    -- If you want to use the `fzf-lua` picker, you can simply set it to `select`
    --
    -- You can also set `picker = "telescope"` without any opts.
    --
    -- For "buffer" picker, you can set the `opts` to the following:
    -- {
    --    hotkeys = true -- Enable hotkeys for the buffer picker to quickly select an action
    --
    --    hotkeys_mode = "text_based" | "text_diff_based" | "sequential"
    --    -- sequential = a, b, c...
    --    -- text_based = "Fix all" => "f", "Fix others" => "o" (first non assigned letter of the action)
    --    -- text_diff_based = "Fix all" => "fa", "Fix others" => "fo" smarter than text_based
    -- }
    picker = "snacks",
    backend_opts = {
      delta = {
        -- Header from delta can be quite large.
        -- You can remove them by setting this to the number of lines to remove
        header_lines_to_remove = 4,

        -- The arguments to pass to delta
        -- If you have a custom configuration file, you can set the path to it like so:
        -- args = {
        --     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
        -- }
        args = {
          "--line-numbers",
        },
      },
    },

    -- The icons to use for the code actions
    -- You can add your own icons, you just need to set the exact action's kind of the code action
    -- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
    signs = {
      quickfix = { "", { link = "DiagnosticWarning" } },
      others = { "", { link = "DiagnosticWarning" } },
      refactor = { "", { link = "DiagnosticInfo" } },
      ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
      ["refactor.extract"] = { "", { link = "DiagnosticError" } },
      ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
      ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      ["source"] = { "", { link = "DiagnosticError" } },
      ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
      ["codeAction"] = { "", { link = "DiagnosticWarning" } },
    },
  },
}
