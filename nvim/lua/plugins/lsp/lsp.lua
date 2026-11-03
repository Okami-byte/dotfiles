return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  opts_extend = { "servers.*.keys" },
  -- LazyVim owns nvim-lspconfig's `config`; do not define one here or it would
  -- replace LazyVim's setup. Declare servers in opts.servers instead and LazyVim
  -- configures and enables them (mason.lua installs the binaries).
  opts = {
    servers = {
      ["*"] = {
        -- Ensure dynamicRegistration is enabled. This lets the LS react to actions
        -- like the Create Unresolved File code action and resolve completions for
        -- unindexed code blocks. Merged with blink.cmp's capabilities by LazyVim.
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
        -- LazyVim's default here is `vim.lsp.buf.code_action` (buffer-local,
        -- always wins over a plain global keymap). Override it in place so
        -- <leader>ca drives tiny-code-action.nvim's picker/diff preview
        -- instead, while keeping the same key, mode, desc and capability
        -- guard as the default.
        keys = {
          {
            "<leader>ca",
            function()
              require("tiny-code-action").code_action()
            end,
            desc = "Code Action",
            mode = { "n", "x" },
            has = "codeAction",
          },
        },
      },
      pyrefly = {},
      html = {},
      ts_ls = {},
      cssls = {},
      marksman = {},
      svelte = {},
      emmet_ls = {},
    },
  },
}
