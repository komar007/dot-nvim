local lsp = require('lsp')

return {
  capabilities = lsp.base_capabilities(),
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
    vim.keymap.set('n', 'gl', function()
      vim.cmd.RustLsp('renderDiagnostic', 'current')
    end, { buf = bufnr, silent = true })
    vim.keymap.set('n', 'gL', function()
      vim.cmd.RustLsp('explainError', 'current')
    end, { buf = bufnr, silent = true })
    vim.keymap.set("n", "<leader>c", function()
      vim.cmd.RustLsp('openCargo')
    end, { buf = bufnr, desc = "Go to Cargo.toml" })
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
