local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- leader must be set before initializing lazy!
vim.g.mapleader = vim.api.nvim_replace_termcodes('<BS>', false, false, true)

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  }
})

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "tabpages"
}
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

require('keymaps')
require('diagnostics')
require('title')
require('folds')
require('readline').set()
require('filetypes')
require('commands')
require('highlight_past_textwidth')
require('playgrounds')
vim.cmd("source " .. vim.fn.stdpath("config") .. "/legacy.vim")
