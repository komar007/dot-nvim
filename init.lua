local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

require("diagnostics")

local utils = require("utils")

utils.autocmd_all({ "BufEnter" }, [[ let &titlestring = "nvim - " . expand("%:t") ]])
vim.opt.title = true

-- look and feel
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,list,full"
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.timeoutlen = 500
vim.opt.updatetime = 500
vim.opt.inccommand = "split"
vim.opt.scrolloff = 8

vim.keymap.set('n', '<F2>', function() vim.o.cursorcolumn = not vim.o.cursorcolumn end, { expr = true })
vim.keymap.set('n', '<F3>', ':IBLToggle<cr>')

vim.cmd 'source ~/.config/nvim/legacy.vim'
