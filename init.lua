local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  }
})

require("diagnostics")

local utils = require("utils")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.o.titlestring = "nvim:  " .. vim.fn.expand("%:t") .. " in  " .. utils.shorten_path(vim.loop.cwd())
  end
})
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
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.fillchars = {
  foldopen = "󰚕",
  foldsep = "│",
  foldclose = "󰬸",
  fold = ' ',

  diff = "╱",
}

vim.opt.foldcolumn = "auto" -- Restore auto behavior
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    vim.opt.foldcolumn = "auto"
    if vim.opt.diff:get() then
      vim.opt.foldtext = 'v:lua.FoldTextInDiff()'
    else
      vim.opt.foldtext = 'v:lua.FoldText()'
    end
  end,
})

function FoldText()
  local line
  for lineno = vim.v.foldstart, vim.v.foldend do
    line = vim.fn.getline(lineno)
    if line:match("^%s*$") == nil then
      break
    end
  end
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%s  %d lines ", line, lines_count)
end

function FoldTextInDiff()
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  return string.format(" %d common lines  ", lines_count)
end

vim.opt.foldtext = 'v:lua.FoldText()'

vim.keymap.set('n', '<F2>', function() vim.o.cursorcolumn = not vim.o.cursorcolumn end, { expr = true })

-- Remove both the character under the cursor and its match
vim.keymap.set('n', '<leader>x', function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = string.sub(vim.api.nvim_get_current_line(), col + 1, col + 1)
  if string.find([[ ([< ]], char, 1, true) then
    vim.api.nvim_feedkeys("mm%x`mx", 'n', true)
  elseif string.find([[ )]> ]], char, 1, true) then
    vim.api.nvim_feedkeys("%mm%x`mx", 'n', true)
  end
end)

require('readline').set()
require('filetypes')
require('commands')
require('playgrounds')
vim.cmd [[ source ~/.config/nvim/legacy.vim ]]
