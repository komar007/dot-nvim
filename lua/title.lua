local utils = require("utils")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.o.titlestring = "nvim:  " .. vim.fn.expand("%:t") .. " in  " .. utils.shorten_path(vim.uv.cwd())
  end
})
vim.opt.title = true
