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
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>" },
  },
}
