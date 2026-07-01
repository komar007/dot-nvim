local function fidget_hide_if_small_window(min_cols, min_lines)
  return function()
    local small = vim.o.columns < min_cols or vim.o.lines < min_lines
    vim.cmd("Fidget suppress " .. tostring(small))
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "VimResized" }, {
  callback = fidget_hide_if_small_window(80, 20)
})

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
      },
    },
  },
}
