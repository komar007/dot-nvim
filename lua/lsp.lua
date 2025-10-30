local M = {}

--vim.lsp.set_log_level("trace")

M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.keymap_opts = { buffer = true, noremap = true, silent = true }

M.on_attach = function(client)
  local snacks = require('snacks')
  -- code navigation shortcuts
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, M.keymap_opts)
  vim.keymap.set('n', 'gD', snacks.picker.lsp_declarations, M.keymap_opts)
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, M.keymap_opts)
  vim.keymap.set('n', 'gi', snacks.picker.lsp_implementations, M.keymap_opts)
  -- docs and info
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, M.keymap_opts)
  vim.keymap.set({ 'n', 'v', 'i' }, '<C-l>', vim.lsp.buf.signature_help, M.keymap_opts)
  vim.keymap.set('n', 'gt', snacks.picker.lsp_type_definitions, M.keymap_opts)
  -- action shortcuts (code actions are implemented in actions_preview.lua
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, M.keymap_opts)
  vim.keymap.set('n', 'gC', vim.lsp.codelens.run, M.keymap_opts)

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
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      callback = vim.lsp.codelens.refresh,
      desc = "Refresh codelens",
      buffer = 0,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_create_user_command(0, 'Fmt', function()
      vim.lsp.buf.format()
    end, {})
  end
end

local caps_for_jsonls = vim.lsp.protocol.make_client_capabilities()
caps_for_jsonls.textDocument.completion.completionItem.snippetSupport = true

require('utils').setup_lsps(
  { capabilities = M.capabilities, on_attach = M.on_attach },
  {
    'bashls',
    {
      'clangd',
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
    },
    'docker_compose_language_service',
    'dockerls',
    {
      'eslint',
      cmd = { "eslint", "--stdio" },
    },
    {
      'gopls',
      settings = {
        gopls = {
          codelenses = {
            test = true,
          },
        },
      },
    },
    'jqls',
    {
      'jsonls',
      capabilities = caps_for_jsonls,
      cmd = { "vscode-json-languageserver", "--stdio" },
    },
    'lua_ls',
    'marksman',
    'nixd',
    'protols',
    'pyright',
    'ruff',
    'taplo',
    'vacuum',
    'vimls',
    'yamlls',
  }
)

return M
