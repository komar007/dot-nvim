return {
  'nvim-treesitter/nvim-treesitter-context',

  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    max_lines = 5,
    min_window_height = 25,
    multiline_threshold = 3,
    trim_scope = 'outer',
    mode = 'cursor',
  },
  keys = {
    { "<F4>", ":TSContextToggle<CR>" },
  },
}
