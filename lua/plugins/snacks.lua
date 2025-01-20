return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    styles = {
      float = {
        wo = {
          winblend = 15,
        },
      },
    },
    picker = {
      sources = {
        buffers = {
          win = {
            input = {
              keys = {
                ["<c-x>"] = { "" },
                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
          },
        },
      },
      layout = function()
        return {
          cycle = true,
          fullscreen = true,
          preset = vim.o.lines >= 70 and "vertical" or "default",
        }
      end,
    },
  },
  keys = {
    { "<C-p>",         ":lua Snacks.picker.buffers()<CR>" },
    { "<Leader><C-p>", ":lua Snacks.picker.files()<CR>" },
    { "<Leader>*",     ":lua Snacks.picker.grep_word()<CR>" },
    { "<Leader>/",     ":lua Snacks.picker.grep()<CR>" },
  }
}
