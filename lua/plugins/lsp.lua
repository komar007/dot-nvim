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
    },
  },
  config = function()
    local border = require('border')
    --vim.lsp.set_log_level("trace")

    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local lsp_keymap_opts = { buffer = true, noremap = true, silent = true }

    local on_lsp_attach = function(client)
      local snacks = require('snacks')
      -- code navigation shortcuts
      vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, lsp_keymap_opts)
      vim.keymap.set('n', 'gD', snacks.picker.lsp_declarations, lsp_keymap_opts)
      vim.keymap.set('n', 'gr', snacks.picker.lsp_references, lsp_keymap_opts)
      vim.keymap.set('n', 'gi', snacks.picker.lsp_implementations, lsp_keymap_opts)
      -- docs and info
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, lsp_keymap_opts)
      vim.keymap.set({ 'n', 'i' }, '<C-l>', vim.lsp.buf.signature_help, lsp_keymap_opts)
      vim.keymap.set('n', 'gt', snacks.picker.lsp_type_definitions, lsp_keymap_opts)
      -- action shortcuts (code actions are implemented in actions_preview.lua
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, lsp_keymap_opts)
      vim.keymap.set('n', 'gC', vim.lsp.codelens.run, lsp_keymap_opts)

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
        'jqls', -- nixpkgs contains an old version, instead, jq-lsp is installed with: nix run nixpkgs#go install github.com/wader/jq-lsp@master
        {
          'jsonls',
          capabilities = caps_for_jsonls,
        },
        'lua_ls',
        'marksman',
        'nixd',
        'protols',
        'vacuum',
        'vimls',
        'yamlls',
      }
    )

    require('lspconfig').pylsp.setup({
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = {
        pylsp = {
          configurationSources = { 'flake8' },
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
        on_attach = function(client)
          on_lsp_attach(client)
          vim.keymap.set('n', 'gl', function()
            vim.cmd.RustLsp('renderDiagnostic', 'current')
          end, lsp_keymap_opts)
          vim.keymap.set('n', 'gL', function()
            vim.cmd.RustLsp('explainError', 'current')
          end, lsp_keymap_opts)
          vim.api.nvim_buf_create_user_command(0, 'CargoToml', function()
            vim.cmd.RustLsp('openCargo')
          end, { nargs = 0 })
        end,
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
