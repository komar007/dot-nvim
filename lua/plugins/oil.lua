return {
  'stevearc/oil.nvim',

  lazy = false,
  opts = {
    git = {
      add = function(path) return false end,
      mv = function(src_path, dest_path) return true end,
      rm = function(path) return true end,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>" },
  },
}
