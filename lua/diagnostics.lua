vim.diagnostic.config({
  virtual_text = {
    prefix = '󰧞',
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

local types = {"Error", "Warn", "Hint", "Info"}
for _ ,type in pairs(types) do
  local hl = "DiagnosticSign" .. type
  local lhl = "DiagnosticSign" .. type .. "Line"
  vim.fn.sign_define(hl, { text = '', numhl = hl, linehl = lhl })
end

vim.keymap.set('n', ']l', vim.diagnostic.goto_next)
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
