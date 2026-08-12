local lsp = require('lsp')

return {
  capabilities = lsp.base_capabilities(),
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
}
