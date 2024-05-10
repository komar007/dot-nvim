return {
  'nvim-treesitter/nvim-treesitter-context',

  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    min_window_height = 25,
    trim_scope = 'outer',
    mode = 'cursor',
  },
  keys = {
    { "<F4>", ":TSContextToggle<CR>" },
  },
}
