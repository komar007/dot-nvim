local function rust_analyzer_first_buffer()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "rust-analyzer" then
      for i, yes in pairs(client.attached_buffers) do
        if yes then
          return i
        end
      end
    end
  end
  return nil
end

local function restart_rust_analyzer_if_changed()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "rust-analyzer" then
      local current_ra_exe = client.config.cmd[1]
      local result = vim.system({ "which", "rust-analyzer" }, { text = true }):wait()
      local system_ra_exe = vim.trim(result.stdout)
      if current_ra_exe ~= system_ra_exe then
        -- :RustAnalyzer wants to be run in the context of a buffer rust-analyzer is attached to...
        local ra_buf = rust_analyzer_first_buffer()
        if ra_buf == nil then
          vim.notify(
            "could not restart rust-analyzer: no attached buffer\nold=" .. current_ra_exe .. "\nnew=" .. system_ra_exe,
            vim.log.levels.WARN
          )
          return
        end
        vim.notify(
          "restarting rust-analyzer\nold=" .. current_ra_exe .. "\nnew=" .. system_ra_exe,
          vim.log.levels.INFO
        )
        vim.api.nvim_buf_call(ra_buf, function()
          vim.cmd.RustAnalyzer("restart")
        end)
        return
      end
    end
  end
end

return {
  'mrcjkb/rustaceanvim',
  version = '^7',
  lazy = false,
  config = function()
    local border = require('border')
    local lsp = require('lsp')
    -- rust LSP is not managed by nix, but installed locally using rustup.
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = border.round,
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

    vim.api.nvim_create_autocmd("User", {
      pattern = "DirenvLoaded",
      callback = function()
        restart_rust_analyzer_if_changed()
      end,
    })
  end,
}
