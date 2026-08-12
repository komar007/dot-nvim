local lsp = require('lsp')

local capabilities = lsp.base_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  capabilities = capabilities,
  cmd = { "vscode-json-languageserver", "--stdio" },
}
