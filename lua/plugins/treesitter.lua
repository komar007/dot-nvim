return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      modules = {},
      ensure_installed = {
        "c",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "java",
        "javascript",
        "jq",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "xml"
      },
      auto_install = false,
      ignore_install = {},
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
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]["] = "@function.inner",
            ["]{"] = "@function.outer",
            ["]a"] = "@parameter.inner",
            ["]s"] = "@class.inner",
          },
          goto_next_end = {
            ["]]"] = "@function.inner",
            ["]}"] = "@function.outer",
            ["]b"] = "@block.inner",
            ["]B"] = "@block.outer",
            ["]A"] = "@parameter.inner",
            ["]S"] = "@class.inner",
          },
          goto_previous_start = {
            ["[["] = "@function.inner",
            ["[{"] = "@function.outer",
            ["[b"] = "@block.inner",
            ["[B"] = "@block.outer",
            ["[a"] = "@parameter.inner",
            ["[s"] = "@class.inner",
          },
          goto_previous_end = {
            ["[]"] = "@function.inner",
            ["[}"] = "@function.outer",
            ["[A"] = "@parameter.inner",
            ["[S"] = "@class.inner",
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
