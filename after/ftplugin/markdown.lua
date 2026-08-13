-- workaround: assume markdown + float = signature help/hover and set better looking options
local is_lsp_float = pcall(vim.api.nvim_win_get_var, 0, "lsp_floating_bufnr")
if is_lsp_float then
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  return
end

vim.opt_local.wrap = false
vim.opt_local.textwidth = 100

require('utils').setup_shell_fmt_buf("mdformat --wrap 100 -", {})
