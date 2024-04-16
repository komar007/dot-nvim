return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
  },
  keys = {
    { "<C-p>",         ":lua telescope_buffers()<CR>" },
    { "<Leader><C-p>", ":lua telescope_findfiles()<CR>" },
    { "<Leader>*",     ":lua telescope_grep_string()<CR>" },
    { "<Leader>/",     ":lua telescope_live_grep()<CR>" },
  },
  config = function()
    local telescope = require('telescope')
    local themes = require('telescope.themes')

    telescope.setup {
      defaults = {
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
      }
    }

    telescope.load_extension('fzf')

    require('dressing').setup({
      input = {
        prompt_align = "left",
        override = function(conf)
          conf.anchor = "NW";
          return conf
        end,
      },
      select = {
        telescope = themes.get_cursor(),
      },
    })

    local fullscreen_theme = themes.get_ivy({
      layout_config = {
        height = 10000,
        width = 10000,
      },
    })

    local fullscreen_horizontal_theme = themes.get_ivy({
      layout_config = {
        height = 10000,
        width = 10000,
      },
      layout_strategy = 'vertical',
    })

    telescope_findfiles = function(config)
      require('telescope.builtin').find_files(fullscreen_theme)
    end
    telescope_buffers = function(config)
      require('telescope.builtin').buffers(fullscreen_theme)
    end
    telescope_references = function(config)
      require('telescope.builtin').lsp_references(fullscreen_horizontal_theme)
    end
    telescope_implementations = function(config)
      require('telescope.builtin').lsp_implementations(fullscreen_horizontal_theme)
    end
    telescope_grep_string = function(config)
      require('telescope.builtin').grep_string(fullscreen_horizontal_theme)
    end
    telescope_live_grep = function(config)
      require('telescope.builtin').live_grep(fullscreen_horizontal_theme)
    end
    telescope_definitions = function(config)
      require('telescope.builtin').lsp_definitions(fullscreen_horizontal_theme)
    end
    telescope_type_definitions = function(config)
      require('telescope.builtin').lsp_type_definitions(fullscreen_horizontal_theme)
    end
  end,
}
