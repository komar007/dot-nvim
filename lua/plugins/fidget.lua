return {
  "j-hui/fidget.nvim",
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
        x_padding = 0,
        winblend = 20,
      },
      view = {
        group_separator = "   ",
      }
    },
  },
}
