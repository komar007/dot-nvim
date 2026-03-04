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

local undo_config = {
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

local bf_picker_config = function()
  local roots = utils.lsp_roots(0)
  local sort = require('snacks.picker.sort').default()
  return {
    matcher = {
      sort_empty = true,
    },
    sort = function(a, b)
      local a_in_root, b_in_root = false, false
      for _, root in ipairs(roots) do
        a_in_root = a_in_root or (a.file ~= nil and a._path:find(root.path, 1, true) == 1)
        b_in_root = b_in_root or (b.file ~= nil and b._path:find(root.path, 1, true) == 1)
      end
      if a_in_root and not b_in_root then
        return true
      end
      if b_in_root and not a_in_root then
        return false
      end
      return sort(a, b)
    end,
  }
end

function _G.yank_gitbrowse_url()
  local value = nil
  require 'snacks'.gitbrowse.open({ open = function(url) value = url end })
  vim.fn.setreg(vim.v.register, value, "v")
end

local function wrap_one_based(idx, n)
  return (idx - 1) % n + 1
end

-- Build a snacks picker action which closes the current picker and opens an alternative one from
-- the group of alternatives, maintaining the input pattern.
--
-- The first group where the current picker is found is used as the group of alternatives. The next
-- item from the group is always selected. When the current picker is the last in the group, the
-- first picker from the group is selected.
---@param alternatives_spec string[][]|{source: string, reuse_opts: string[]}[][]
local function make_alternate_picker_action(alternatives_spec)
  local alternatives = utils.map2(alternatives_spec, function(item)
    if type(item) == "table" then
      return item
    elseif type(item) == "string" then
      return { source = item, reuse_opts = {} }
    else
      error("bad picker alternative spec")
    end
  end)
  ---@param current_picker snacks.Picker
  return function(current_picker)
    local alt_picker = nil
    for _, group in ipairs(alternatives) do
      for i, alt in ipairs(group) do
        if current_picker.opts.source == alt.source then
          alt_picker = group[wrap_one_based(i + 1, #group)]
          goto end_search
        end
      end
    end
    ::end_search::
    if alt_picker == nil then
      return
    end
    local new_opts = {
      show_empty = true, -- so that the cycle is not broken by some of the pickers never appearing
      pattern = current_picker:filter().pattern,
      search = current_picker:filter().search,
      live = current_picker.opts.live,
    }
    for _, opt in ipairs(alt_picker.reuse_opts) do
      new_opts[opt] = current_picker.opts[opt]
    end
    current_picker:close()
    require 'snacks'.picker(alt_picker.source, new_opts)
  end
end

local bf_specific_opts = {}
for k, _ in pairs(bf_picker_config()) do
  table.insert(bf_specific_opts, k)
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
            ["<C-u>"] = { "preview_scroll_up", mode = { "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "n" } },
            ["<C-a>"] = { "select_all", mode = { "n" } },
            ["<leader>"] = { "switch_alternate_picker", mode = { "n" } },
          })
        },
      },
      actions = {
        switch_alternate_picker = make_alternate_picker_action({
          {
            { source = "buffers", reuse_opts = bf_specific_opts },
            { source = "files",   reuse_opts = bf_specific_opts },
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
            file = "/+/refs/heads/{branch}/{file}#{line_start}"
          },
        }
        config.url_patterns = vim.tbl_deep_extend('force', config.url_patterns, url_patterns)
      end,
    },
  },
  keys = {
    { "<C-p>",         function() require 'snacks'.picker.buffers(bf_picker_config()) end },
    { "<Leader><C-p>", function() require 'snacks'.picker.files(bf_picker_config()) end },
    { "g*",            function() require 'snacks'.picker.grep_word() end },
    { "g/",            function() require 'snacks'.picker.grep() end },

    { "<Leader>u",     function() require 'snacks'.picker.undo(undo_config) end },
    { "<Leader>gd",    function() require 'snacks'.picker.git_diff() end },
    { "<Leader>gl",    function() require 'snacks'.picker.git_log() end },
    { "<Leader>glf",   function() require 'snacks'.picker.git_log_file() end },
    { "<Leader>gll",   function() require 'snacks'.picker.git_log_line() end },

    { "<Leader>gb",    function() require 'snacks'.gitbrowse() end,             mode = { 'n', 'x' } },
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
