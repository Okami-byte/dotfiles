-- vim ui2
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    target = "msg", -- options: cmd(classic), msg(similar to noice)
    pager = { height = 1 },
    msg = { height = 0.5, timeout = 4500 },
    dialog = { height = 0.5 },
    cmd = { height = 0.5 },
  },
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("current-theme")
