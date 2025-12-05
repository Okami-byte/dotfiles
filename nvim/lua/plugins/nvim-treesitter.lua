return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    opts = {
      ensure_installed = {
        "lua",
        "sql",
        "go",
        "regex",
        "bash",
        "markdown",
        "markdown_inline",
        "latex",
        "python",
        "yaml",
        "json",
        "jsonc",
        "cpp",
        "csv",
        "java",
        "javascript",
        "python",
        "dockerfile",
        "html",
        "css",
        "templ",
        "php",
        "promql",
        "glsl",
        "dockerfile",
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
    },
  },
}
