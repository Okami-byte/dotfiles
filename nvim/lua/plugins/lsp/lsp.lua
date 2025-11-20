return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
},
  config == function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import blink plugin
    local capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }

    opts({ "s" })

    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    capabilities.workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    }

    -- Servers

    vim.lsp.enable("pyrefly")
    vim.lsp.enable("html")
    vim.lsp.enable("tsserver")
    vim.lsp.enable("cssls")
    vim.lsp.enable("marksman")
    vim.lsp.enable("svelte")
    vim.lsp.enable("emmet_ls")
  end
