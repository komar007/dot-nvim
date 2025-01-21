return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },
  },
  lazy = false,
  config = function()
    local telescope = require('telescope')

    telescope.setup {
      defaults = {
        winblend = 15,
        path_display = { "truncate" },
      },
    }

    telescope.load_extension('fzf')
  end,
}
