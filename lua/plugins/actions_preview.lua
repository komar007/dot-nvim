return {
  "aznhe21/actions-preview.nvim",

  dependencies = {
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
  },
  lazy = false,
  keys = {
    { "ga", (function() require("actions-preview").code_actions() end), mode = { "v", "n" } },
  },
}
