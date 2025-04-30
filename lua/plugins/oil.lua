vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'ORun', function(opts)
      local dir = require('oil').get_current_dir(nil)
      if dir == nil then
        vim.notify("Oil not running", vim.log.levels.ERROR) -- should never happen...
        return
      end
      local cmd = opts.args:gsub('%%O', dir)
      vim.cmd(cmd)
    end, { nargs = 1 })
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
