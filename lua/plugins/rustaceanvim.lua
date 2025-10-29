return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    local border = require('border')
    local lsp = require('lsp')
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
        capabilities = lsp.capabilities,
        on_attach = function(client)
          lsp.on_attach(client)
          vim.keymap.set('n', 'gl', function()
            vim.cmd.RustLsp('renderDiagnostic', 'current')
          end, lsp.keymap_opts)
          vim.keymap.set('n', 'gL', function()
            vim.cmd.RustLsp('explainError', 'current')
          end, lsp.keymap_opts)
          vim.keymap.set("n", "<leader>c", function()
            vim.cmd.RustLsp('openCargo')
          end, { buffer = true, desc = "Go to Cargo.toml" })
        end,
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = false,
            },
            check = {
              command = "clippy",
            },
          },
        },
      },
    }
  end,
}
