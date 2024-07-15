return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "c",
        "css",
        "dockerfile",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "nix",
        "python",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "xml"
      },
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ib"] = "@block.inner",
            ["ab"] = "@block.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]["] = "@function.inner",
            ["]{"] = "@function.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]]"] = "@function.inner",
            ["]}"] = "@function.outer",
            ["]b"] = "@block.inner",
            ["]B"] = "@block.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[["] = "@function.inner",
            ["[{"] = "@function.outer",
            ["[b"] = "@block.inner",
            ["[B"] = "@block.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[]"] = "@function.inner",
            ["[}"] = "@function.outer",
            ["[A"] = "@parameter.inner",
          },
        },
      },
    }

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
