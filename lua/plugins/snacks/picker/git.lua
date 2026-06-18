local function normalize(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local utils = require('utils')

local M = {}

--- Picker config for git_status
---@param promoted_file string The file which should be sorted first
---@return snacks.picker.Config
function M.status_config_for_promoted_file(promoted_file)
  return {
    matcher = {
      sort_empty = true,
    },
    sort = function(a, b)
      local origin = normalize(promoted_file)
      local git = require('snacks.picker.source.git')
      local a_unmerged = git.git_status(a.status).unmerged or false
      local b_unmerged = git.git_status(b.status).unmerged or false
      if a_unmerged ~= b_unmerged then
        return a_unmerged and not b_unmerged
      end

      local a_is_promoted = normalize(a.file) == origin
      local b_is_promoted = normalize(b.file) == origin
      if a_is_promoted ~= b_is_promoted then
        return a_is_promoted
      end
      return a.idx < b.idx
    end,
    win = {
      input = {
        keys = {
          ["<Tab>"] = { "select_and_next", mode = { "n", "i" } },
          ["<C-S>"] = { "git_stage", mode = { "n", "i" } },
          ["<C-R>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
        },
      },
    },
  }
end

---@return snacks.picker.Config
function M.log_config()
  return {
    actions = {
      yank_commit_sha = { action = "yank", reg = '"', field = "commit" },
      yank_commit_sha_clip = { action = "yank", reg = '+', field = "commit" },
    },
    win = {
      input = {
        keys = utils.keys_with_alternate {
          ["<C-y>"] = { "yank_commit_sha", mode = { "n", "i" } },
          ["Y"] = { "yank_commit_sha_clip", mode = { "n" } },
        },
      },
    },
  }
end

return M
