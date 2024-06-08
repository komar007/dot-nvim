return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mrcjkb/rustaceanvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local border = require('border')
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local on_lsp_attach = function(client)
      local keymap_opts = { noremap = true, silent = true }
      -- code navigation shortcuts
      vim.keymap.set('n', 'gd', telescope_definitions, keymap_opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
      vim.keymap.set('n', 'gr', telescope_references, keymap_opts)
      vim.keymap.set('n', 'gi', telescope_implementations, keymap_opts)
      -- docs and info
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
      vim.keymap.set('n', 'gt', telescope_type_definitions, keymap_opts)
      vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, keymap_opts)
      -- action shortcuts (code actions are implemented in actions_preview.lua
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, keymap_opts)
      vim.keymap.set('n', 'gc', vim.lsp.codelens.run, keymap_opts)

      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = 0, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
          callback = vim.lsp.buf.document_highlight,
          group = "lsp_document_highlight",
          desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = vim.lsp.buf.clear_references,
          group = "lsp_document_highlight",
          desc = "Clear All the References",
        })
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        callback = vim.lsp.codelens.refresh,
        desc = "Refresh codelens",
      })

      vim.api.nvim_create_user_command('Fmt', function()
        vim.lsp.buf.format()
      end, {})
    end

    local defcfg = { capabilities = capabilities, on_attach = on_lsp_attach }

    -- gentoo's sys-devel/clang should provide clangd
    require('lspconfig').clangd.setup(defcfg)
    -- pipx install 'python-lsp-server[all]'
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
    -- npm install -g dockerfile-language-server-nodejs
    require('lspconfig').dockerls.setup(defcfg)
    -- npm install -g vim-language-server
    require('lspconfig').vimls.setup(defcfg)
    -- npm i -g vscode-langservers-extracted
    require('lspconfig').eslint.setup(defcfg)
    -- npm i -g dockerfile-language-server-nodejs
    require('lspconfig').dockerls.setup(defcfg)
    -- npm i -g dockerfile-language-server-nodejs
    require('lspconfig').kotlin_language_server.setup(defcfg)

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

    require('lspconfig').gopls.setup(defcfg)

    require('lspconfig').lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {}
      }
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = border,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = border,
    })
  end,
}
