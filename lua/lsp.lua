local M = {}

local lsp_float_opts = {
  wrap = true,
  max_width = 100,
}

--- @return lsp.ClientCapabilities
function M.base_capabilities()
  return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- TODO: are we sure "current buffer" is always well defined when adding these keymaps?
-- could an LSP be attached to non-current buffer?
M.keymap_opts = { buf = 0, silent = true }

M.on_attach = function(client)
  local snacks = require('snacks')
  -- code navigation shortcuts
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, M.keymap_opts)
  vim.keymap.set('n', 'gD', snacks.picker.lsp_declarations, M.keymap_opts)
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, M.keymap_opts)
  vim.keymap.set('n', 'gi', snacks.picker.lsp_implementations, M.keymap_opts)
  -- docs and info
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover(lsp_float_opts) end, M.keymap_opts)
  vim.keymap.set({ 'n', 'v', 'i' }, '<C-l>', function() vim.lsp.buf.signature_help(lsp_float_opts) end, M.keymap_opts)
  vim.keymap.set('n', 'gt', snacks.picker.lsp_type_definitions, M.keymap_opts)
  -- action shortcuts (code actions are implemented in actions_preview.lua
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, M.keymap_opts)
  -- executing code lenses is implemented via smart-codelens-run.nvim

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = 0, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
      buffer = 0,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
      buffer = 0,
    })
  end

  if client.server_capabilities.codeLensProvider then
    vim.lsp.codelens.enable(true, { bufnr = 0 })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_create_user_command(0, 'Fmt', function()
      vim.lsp.buf.format()
    end, {})
  end
end

function M.setup()
  --vim.lsp.set_log_level("trace")

  vim.lsp.config("*", {
    capabilities = M.base_capabilities(),
    on_attach = M.on_attach
  })

  vim.lsp.enable({
    'bashls',
    'clangd',
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'fsautocomplete',
    'gopls',
    'hls',
    'jqls',
    'jsonls',
    'emmylua_ls',
    'marksman',
    'nixd',
    'postgres_lsp',
    'protols',
    'pyright',
    'ruff',
    'taplo',
    'ts_ls',
    'vacuum',
    'vimls',
    'yamlls',
  })
end

return M
