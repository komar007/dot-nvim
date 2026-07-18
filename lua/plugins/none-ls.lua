return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'poljar/typos.nvim',
  },
  opts = function()
    return {
      sources = {
        require('typos').actions,
        require('typos').diagnostics,
      },
    }
  end,
}
