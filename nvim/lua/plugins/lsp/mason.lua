return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "emmet_ls",
        "pyrefly",
        "eslint",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "󰇘",
              package_uninstalled = "✗",
            },
          },
        },
        "neovim/nvim-lspconfig",
      },
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "ruff", -- python formatter
          "eslint_d",
        },
      },
      dependencies = {
        "mason-org/mason.nvim",
      },
    },
  },
}
