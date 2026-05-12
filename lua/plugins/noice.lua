return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = function()
    vim.cmd [[ hi NoiceCmdlineIcon guifg=#67a23e guibg=#333352 gui=bold ]]
    vim.cmd [[ hi NoiceCmdlineIconSearch guifg=#000000 guibg=#fabd2f gui=bold ]]
    vim.cmd [[ hi link NoiceConfirmBorder FloatBorder ]]
    vim.cmd [[ hi NoiceFormatProgressDone gui=reverse guifg=#446699 guibg=#1d2021 ]]
    return {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  > " },
          search_down = { icon = "  / ", },
          search_up = { icon = "  ? ", },
          help = { icon = "  help " },
          lua = { icon = "   " },
        },
      },
      messages = { view_search = false },
      lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
        documentation = { enabled = false },
      },
      markdown = { enabled = false },
      views = {
        confirm = {
          position = {
            row = "90%",
          },
        },
        mini = {
          border = { style = require('border').fidget },
          timeout = 4000,
        },
      },
    }
  end,
  keys = {
    { "<leader>n", "<cmd>Noice history<cr>", desc = "show Noice notification history" },
  },
}
