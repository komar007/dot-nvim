return {
  'lewis6991/satellite.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  opts = {
    winblend = 0,
    handlers = {
      cursor = {
        symbols = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
      },
      gitsigns = {
        enable = false,
        signs = {
          add = "▐",
          change = "▐",
          delete = "╺",
        },
      },
    },
  },
}
