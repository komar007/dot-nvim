-- leader must be set before initializing lazy!
vim.g.mapleader = vim.api.nvim_replace_termcodes('<BS>', false, false, true)

require('lazy_nvim_bootstrap')
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  lockfile = vim.env.LAZY_NVIM_LOCKFILE or (vim.fn.stdpath("config") .. "/lazy-lock.json")
})

vim.opt.shada = "'1000,<50,s10,h"
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "tabpages"
}
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,list,full"
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.timeoutlen = 500
vim.opt.updatetime = 250
vim.opt.inccommand = "split"
vim.opt.scrolloff = 8
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.formatoptions:append("1")
vim.opt.fillchars = {
  foldopen = "󰚕",
  foldsep = "│",
  foldclose = "󰬸",
  fold = ' ',

  diff = "╱",
}
vim.opt.laststatus = 3

require('lazy_headless')
require('keymaps')
require('diagnostics')
require('title')
require('folds')
require('readline').set()
require('filetypes')
require('commands')
require('highlight_past_textwidth')
require('playgrounds')
require('lsp')
vim.cmd("source " .. vim.fn.stdpath("config") .. "/legacy.vim")

vim.opt.exrc = true
