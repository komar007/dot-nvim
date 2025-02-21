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
        x_padding = 1,
        y_padding = 1,
        winblend = 20,
      },
      view = {
        group_separator = "   ",
      }
    },
  },
}
