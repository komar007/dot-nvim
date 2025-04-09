local function keys_but_unbind(unbind, keys)
  for _, key in pairs(unbind) do
    keys[key] = { "" }
  end
  return keys
end

local readline = require('readline')
local utils = require('utils')

UndoConfig = {
  actions = {
    yank_add = { action = "yank", reg = '"', field = "added_lines" },
    yank_del = { action = "yank", reg = '"', field = "removed_lines" },
  },
  win = {
    input = {
      keys = utils.keys_with_alternate {
        ["<C-y>"] = { "yank_add", mode = { "n", "i" } },
        ["<C-S-y>"] = { "yank_del", mode = { "n", "i" } },
      },
    },
  },
  layout = {
    fullscreen = true,
    preset = "default",
    cycle = false
  }
}

return {
  "folke/snacks.nvim",
  tag = "v2.21.0",
  priority = 1000,
  lazy = false,

  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    styles = {
      float = {
        wo = {
          winblend = 15,
        },
      },
      input = {
        relative = "cursor",
        row = 1,
        title_pos = "left",
      },
    },
    input = {
    },
    scroll = {
      animate = {
        duration = { step = 20, total = 200 },
        easing = "inOutExpo",
      },
    },
    picker = {
      matcher = {
        frecency = true,
        cwd_bonus = true,
      },
      win = {
        input = {
          keys = keys_but_unbind(readline.keys, utils.keys_with_alternate {
            ["<C-S-p>"] = { "history_back", mode = { "i", "n" } },
            ["<C-S-n>"] = { "history_forward", mode = { "i", "n" } },
          })
        },
      },
      layout = function()
        return {
          cycle = true,
          fullscreen = true,
          preset = vim.o.lines >= 70 and "vertical" or "default",
        }
      end,
      formatters = {
        file = {
          truncate = 120,
        },
      },
    },
  },
  keys = {
    { "<C-p>",         function() require'snacks'.picker.buffers() end },
    { "<Leader><C-p>", function() require'snacks'.picker.files() end },
    { "<Leader>*",     function() require'snacks'.picker.grep_word() end },
    { "<Leader>/",     function() require'snacks'.picker.grep() end },
    { "<Leader>u",     function() require'snacks'.picker.undo(UndoConfig) end },
    { "<Leader>gd",    function() require'snacks'.picker.git_diff() end },
    { "<Leader>gl",    function() require'snacks'.picker.git_log() end },
    { "<Leader>glf",   function() require'snacks'.picker.git_log_file() end },
    { "<Leader>gll",   function() require'snacks'.picker.git_log_line() end },
  }
}
