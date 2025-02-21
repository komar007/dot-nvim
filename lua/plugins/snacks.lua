local function unbind_keys_def(keys)
  local def = {}
  for _, key in pairs(keys) do
    def[key] = { "" }
  end
  return def
end

local readline = require('readline')

UndoConfig = {
  actions = {
    yank_add = { action = "yank", reg = '"', field = "added_lines" },
    yank_del = { action = "yank", reg = '"', field = "removed_lines" },
  },
  win = {
    input = {
      keys = {
        ["<c-y>"] = { "yank_add", mode = { "n", "i" } },
        ["<Char-0xE105>"] = { "yank_del", mode = { "n", "i" } }, -- C-S-y mapped in alacritty
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
          keys = unbind_keys_def(readline.keys),
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
    { "<C-p>",         ":lua Snacks.picker.buffers()<CR>" },
    { "<Leader><C-p>", ":lua Snacks.picker.files()<CR>" },
    { "<Leader>*",     ":lua Snacks.picker.grep_word()<CR>" },
    { "<Leader>/",     ":lua Snacks.picker.grep()<CR>" },
    { "<Leader>u",     ":lua Snacks.picker.undo(UndoConfig)<CR>" },
  }
}
