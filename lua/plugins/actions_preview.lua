return {
  "aznhe21/actions-preview.nvim",

  dependencies = {
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
  },
  lazy = false,
  opts = function()
    return {
      telescope = require('telescope.themes').get_dropdown({
        layout_config = {
          height = 20,
          width = 125,
        },
        layout_strategy = 'cursor',
      })
    }
  end,
  keys = {
    { "ga", (function() require("actions-preview").code_actions() end), mode = { "v", "n" } },
  },
}
