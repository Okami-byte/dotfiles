return {
  "github/copilot.vim",
  config = false,
  keymaps = {
    accept = "<C-e>", --FIX: fix keymap for acceptance as this doesn't work currently
    accept_line = "<C-l>",
    accept_word = false,
    next = "<C-]>",
    prev = "<C-[>",
    dismiss = "<C-c>",
  },
}
