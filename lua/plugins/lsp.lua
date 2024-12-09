return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'mrcjkb/rustaceanvim',
      version = '^5',
      lazy = false,
    },
    {
      'saecki/crates.nvim',
      tag = 'stable'
    },
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local border = require('border')
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local on_lsp_attach = function(client)
      local keymap_opts = { noremap = true, silent = true }
      -- code navigation shortcuts
      vim.keymap.set('n', 'gd', Telescope_definitions, keymap_opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
      vim.keymap.set('n', 'gr', Telescope_references, keymap_opts)
      vim.keymap.set('n', 'gi', Telescope_implementations, keymap_opts)
      -- docs and info
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
      vim.keymap.set('n', 'gt', Telescope_type_definitions, keymap_opts)
      vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, keymap_opts)
      -- action shortcuts (code actions are implemented in actions_preview.lua
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, keymap_opts)
      vim.keymap.set('n', 'gC', vim.lsp.codelens.run, keymap_opts)

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
      { capabilities = capabilities, on_attach = on_lsp_attach },
      {
        'bashls',
        {
          'clangd',
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
        },
        'docker_compose_language_service',
        'dockerls',
        'eslint',
        'gopls',
        {
          'jsonls',
          capabilities = caps_for_jsonls,
        },
        'lua_ls',
        'marksman',
        'nixd',
        'protols', -- not available in nixpkgs, must be installed with: cargo install protols
        'vimls',
      }
    )

    require('lspconfig').pylsp.setup({
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = {
        pylsp = {
          configurationSources = {'flake8'},
          plugins = {
            flake8 = {
              enabled = true,
            },
            pycodestyle = {
              enabled = false,
            },
            mccabe = {
              enabled = false,
            },
            pyflakes = {
              enabled = false,
            },
          }
        }
      }
    })

    -- rust LSP is not managed by nix, but installed locally using rustup.
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = border,
        },
        inlay_hints = {
          highlight = "InlayHint",
        },
      },
      server = {
        capabilities = capabilities,
        on_attach = on_lsp_attach,
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = true,
            },
            check = {
              command = "clippy",
            },
          },
        },
      },
    }

    require('crates').setup {
      lsp = {
        enabled = true,
        on_attach = on_lsp_attach,
        actions = true,
        hover = true,
        completion = true,
      },
      completion = {
        crates = {
          enabled = true,
          max_results = 20,
          min_chars = 3,
        }
      },
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = border,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = border,
    })

    require('lspconfig.ui.windows').default_options.border = border
  end,
}
