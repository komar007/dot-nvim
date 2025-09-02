return {
  'lewis6991/satellite.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  opts = {
    handlers = {
      cursor = {
        symbols = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
      },
      gitsigns = {
        signs = {
          add = "▐",
          change = "▐",
          delete = "╺",
        },
      },
    },
  },
}
