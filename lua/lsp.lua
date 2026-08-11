local M = {}

--vim.lsp.set_log_level("trace")

local lsp_float_opts = {
  wrap = true,
  max_width = 100,
}

--- @return lsp.ClientCapabilities
local function base_capabilities()
  return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

M.capabilities = base_capabilities()

-- TODO: are we sure "current buffer" is always well defined when adding these keymaps?
-- could an LSP be attached to non-current buffer?
local keymap_opts = { buf = 0, silent = true }

M.on_attach = function(client)
  local snacks = require('snacks')
  -- code navigation shortcuts
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, keymap_opts)
  vim.keymap.set('n', 'gD', snacks.picker.lsp_declarations, keymap_opts)
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, keymap_opts)
  vim.keymap.set('n', 'gi', snacks.picker.lsp_implementations, keymap_opts)
  -- docs and info
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover(lsp_float_opts) end, keymap_opts)
  vim.keymap.set({ 'n', 'v', 'i' }, '<C-l>', function() vim.lsp.buf.signature_help(lsp_float_opts) end, keymap_opts)
  vim.keymap.set('n', 'gt', snacks.picker.lsp_type_definitions, keymap_opts)
  -- action shortcuts (code actions are implemented in actions_preview.lua
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, keymap_opts)
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

vim.lsp.config("*", { capabilities = M.capabilities, on_attach = M.on_attach })

vim.lsp.config('clangd', {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

vim.lsp.config('eslint', {
  cmd = { "eslint", "--stdio" },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      codelenses = {
        test = true,
      },
    },
  },
})

local caps_for_jsonls = base_capabilities()
caps_for_jsonls.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config('jsonls', {
  capabilities = caps_for_jsonls,
  cmd = { "vscode-json-languageserver", "--stdio" },
})

vim.lsp.config('emmylua_ls', {
  -- the following config is based on
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#emmylua_ls
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and
          (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
      then
        client.config.settings = {}
      end
    end
  end,
  settings = {
    emmylua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
})

vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.config('protols', {
  root_markers = { "protols.toml", ".git" },
})

vim.lsp.config("rust-analyzer", {
  capabilities = M.capabilities,
  on_attach = function(client)
    M.on_attach(client)
    vim.keymap.set('n', 'gl', function()
      vim.cmd.RustLsp('renderDiagnostic', 'current')
    end, keymap_opts)
    vim.keymap.set('n', 'gL', function()
      vim.cmd.RustLsp('explainError', 'current')
    end, keymap_opts)
    vim.keymap.set("n", "<leader>c", function()
      vim.cmd.RustLsp('openCargo')
    end, { buf = 0, desc = "Go to Cargo.toml" })
  end,
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
        enableExperimental = false,
      },
      hover = {
        show = {
          traitAssocItems = 5,
        },
      },
      signatureInfo = {
        -- "full" causes the whole signature to be in one line and it becomes a mess,
        -- showing just parameters is a workaround.
        detail = "parameters",
      },
      check = {
        command = "clippy",
      },
    },
  },
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

return M
