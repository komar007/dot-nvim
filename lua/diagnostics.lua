vim.diagnostic.config({
  virtual_text = {
    prefix = '󱓻 ',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignErrorLine",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarnLine",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfoLine",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHintLine",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})

vim.keymap.set('n', ']l', function() vim.diagnostic.goto_next({ wrap = false }) end)
vim.keymap.set('n', '[l', function() vim.diagnostic.goto_prev({ wrap = false }) end)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ wrap = false, severity = vim.diagnostic.severity.ERROR })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ wrap = false, severity = vim.diagnostic.severity.ERROR })
end)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.keymap.set('n', '<F5>', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })
