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

function _G.yank_gitbrowse_url()
  local value = nil
  require 'snacks'.gitbrowse.open({ open = function(url) value = url end })
  vim.fn.setreg(vim.v.register, value, "v")
end

return {
  "komar007/snacks.nvim",
  branch = "stable_plus",
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
      previewers = {
        diff = {
          -- FIXME: fancy is disabled because it uses the same highlight (DiffDelete) as the area
          -- used by diffview in side-by-side mode where it is set to very dark red background.
          -- This makes sense in the side-by-side mode because it is always a "grayed-out" area
          -- with no text, but in unified mode the deleted background is almost invisible, which is
          -- not as indented. This should be fixed in diffview's configuration, as the current
          -- setting of DiffDelete is likely only valid for DiffView.
          style = 'syntax',
        },
      },
    },
    gitbrowse = {
      config = function(config, _)
        local remote_patterns = {
          { "^ssh://[^@]+@gerrit.([^:/]+)(:[0-9]+)\\?/(.+)$", "https://gerrit.%1/plugins/gitiles/%3" }
        }
        vim.list_extend(remote_patterns, config.remote_patterns)
        config.remote_patterns = remote_patterns

        local url_patterns = {
          ["gerrit."] = {
            file = "/+/refs/heads/{branch}/{file}#{line_start}"
          },
        }
        config.url_patterns = vim.tbl_deep_extend('force', config.url_patterns, url_patterns)
      end,
    },
  },
  keys = {
    { "<C-p>",         function() require 'snacks'.picker.buffers() end },
    { "<Leader><C-p>", function() require 'snacks'.picker.files() end },
    { "<Leader>*",     function() require 'snacks'.picker.grep_word() end },
    { "<Leader>/",     function() require 'snacks'.picker.grep() end },

    { "<Leader>u",     function() require 'snacks'.picker.undo(UndoConfig) end },
    { "<Leader>gd",    function() require 'snacks'.picker.git_diff() end },
    { "<Leader>gl",    function() require 'snacks'.picker.git_log() end },
    { "<Leader>glf",   function() require 'snacks'.picker.git_log_file() end },
    { "<Leader>gll",   function() require 'snacks'.picker.git_log_line() end },

    { "<Leader>gb",    function() require 'snacks'.gitbrowse() end,            mode = { 'n', 'x' } },
    {
      "ygb",
      function()
        vim.go.operatorfunc = "v:lua.yank_gitbrowse_url"
        return "g@l"
      end,
      expr = true
    },
  }
}
