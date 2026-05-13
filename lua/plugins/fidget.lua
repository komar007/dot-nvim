return {
  "j-hui/fidget.nvim",
  lazy = false,
  keys = {
    { "<leader>n", "<cmd>Fidget history<cr>", desc = "show Fidget notification history" },
  },
  opts = {
    progress = {
      display = {
        progress_icon = {
          pattern = { "▱▱▱ ", "▰▱▱ ", "▰▰▱ ", "▰▰▰ ", "▱▰▰ ", "▱▱▰ " },
          period = 1
        },
      },
    },
    notification = {
      override_vim_notify = true,
      window = {
        normal_hl = "FidgetFloat",
        x_padding = 1,
        y_padding = 0,
        max_width = 80,
        max_height = 40,
        winblend = 0,
        border = require("border").fidget,
      },
      view = {
        group_separator = "   ",
        group_separator_hl = "NormalFloat",
      }
    },
  },
}
