local function keys_but_unbind(unbind, keys)
  for _, key in pairs(unbind) do
    if keys[key] == nil then
      keys[key] = { "" }
    end
  end
  return keys
end

local readline = require('readline')
local utils = require('utils')
local alternate = require('plugins.snacks.picker.alternate')

local function yank_gitbrowse_url(what)
  local value = nil
  require 'snacks'.gitbrowse.open({ notify = false, what = what, open = function(url) value = url end })
  vim.fn.setreg(vim.v.register, value, "v")
end

function _G.yank_gitbrowse_url(_)
  yank_gitbrowse_url(nil)
end

function _G.yank_gitbrowse_url_permalink(_)
  yank_gitbrowse_url("permalink")
end

---@return snacks.picker.Config
local function buffers_files_picker_source_config(opts)
  local roots = utils.lsp_roots(0)
  return vim.tbl_deep_extend(
    'force',
    opts,
    require('plugins.snacks.picker.buffers_files').for_roots(roots)
  )
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
      sources = {
        buffers = { config = buffers_files_picker_source_config },
        files = { config = buffers_files_picker_source_config },
        git_status = require('plugins.snacks.picker.git_status'),
        undo = require('plugins.snacks.picker.undo'),
      },
      win = {
        input = {
          keys = keys_but_unbind(readline.keys, utils.keys_with_alternate {
            ["<C-S-p>"] = { "history_back", mode = { "i", "n" } },
            ["<C-S-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "n" } },
            ["<C-a>"] = { "select_all", mode = { "n" } },
            ["<leader>"] = { "switch_alternate_picker", mode = { "n" } },
          })
        },
      },
      actions = {
        switch_alternate_picker = alternate.make_alternate_picker_action({
          {
            "buffers",
            "files",
          },
          {
            "git_log",
            "git_log_line",
            "git_log_file",
          },
        }),
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
          style = 'terminal',
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
            file = "/+/refs/heads/{branch}/{file}#{line_start}",
            permalink = "/+/{commit}/{file}#{line_start}",
          },
        }
        config.url_patterns = vim.tbl_deep_extend('force', config.url_patterns, url_patterns)
      end,
    },
  },
  keys = {
    { "<C-p>",         function() require 'snacks'.picker.buffers() end },
    { "<Leader><C-p>", function() require 'snacks'.picker.files() end },
    { "g*",            function() require 'snacks'.picker.grep_word() end },
    { "g/",            function() require 'snacks'.picker.grep() end },

    { "<Leader>u",     function() require 'snacks'.picker.undo() end },
    { "<Leader>gd",    function() require 'snacks'.picker.git_diff() end },
    { "<Leader>gl",    function() require 'snacks'.picker.git_log() end },
    { "<Leader>glf",   function() require 'snacks'.picker.git_log_file() end },
    { "<Leader>gll",   function() require 'snacks'.picker.git_log_line() end },
    { "<Leader>gg",    function() require 'snacks'.picker.git_status() end },

    {
      "<Leader>gb",
      function()
        require 'snacks'.gitbrowse()
      end,
      mode = { 'n', 'x' }
    },
    {
      "<Leader>gp",
      function()
        require 'snacks'.gitbrowse.open({ what = "permalink" })
      end,
      mode = { 'n', 'x' }
    },
    {
      "ygb",
      function()
        vim.go.operatorfunc = "v:lua.yank_gitbrowse_url"
        return "g@l"
      end,
      expr = true
    },
    {
      "ygp",
      function()
        vim.go.operatorfunc = "v:lua.yank_gitbrowse_url_permalink"
        return "g@l"
      end,
      expr = true
    },
  }
}
