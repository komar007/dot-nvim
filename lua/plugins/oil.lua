vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    local function o_cmd(args)
      local dir = require('oil').get_current_dir(nil)
      if dir == nil then
        vim.notify("Oil not running", vim.log.levels.ERROR) -- should never happen...
        return
      end
      local cmd = args:gsub('%%O', dir)
      vim.cmd(cmd)
    end;
    vim.api.nvim_buf_create_user_command(0, 'OCmd', function(opts) o_cmd(opts.args) end,
      { nargs = 1, complete = "command" })
    vim.api.nvim_buf_create_user_command(0, 'ORun', function(opts)
      local cmd = "!(cd %O && " .. opts.args .. ")"
      o_cmd(cmd)
    end, { nargs = 1, complete = "shellcmd" })
  end
})

return {
  'stevearc/oil.nvim',

  lazy = false,
  opts = {
    git = {
      add = function(path) return false end,
      mv = function(src_path, dest_path) return true end,
      rm = function(path) return true end,
    },
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>" },
  },
}
