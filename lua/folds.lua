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
