return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },
    "debugloop/telescope-undo.nvim",
  },
  keys = {
    { "<Leader>u",     "<cmd>Telescope undo<CR>" },
  },
  config = function()
    local telescope = require('telescope')
    local telescope_themes = require('telescope.themes')

    telescope.setup {
      defaults = {
        winblend = 15,
        path_display = { "truncate" },
        mappings = {
          n = {
            ['<c-d>'] = require('telescope.actions').delete_buffer
          },
          i = {
            ['<c-d>'] = require('telescope.actions').delete_buffer
          },
        },
      },
      extensions = {
        undo = {
          side_by_side = false,
          layout_strategy = "vertical",
          layout_config = {
            prieview_height = 0.8,
          },
        },
      },
    }

    telescope.load_extension('fzf')
    telescope.load_extension('undo')

    local themes = {
      fullscreen = function()
        return telescope_themes.get_ivy({
          layout_config = {
            height = 10000,
            width = 10000,
          },
        })
      end,
      fullscreen_horizontal = function()
        return telescope_themes.get_ivy({
          layout_config = {
            height = 10000,
            width = 10000,
          },
          layout_strategy = 'vertical',
        })
      end,
    }
  end,
}
