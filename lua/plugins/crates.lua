return {
  'saecki/crates.nvim',
  config = function()
    local lsp = require('lsp')
    require('crates').setup {
      lsp = {
        enabled = true,
        on_attach = lsp.on_attach,
        actions = true,
        hover = true,
        completion = true,
      },
      completion = {
        crates = {
          max_results = 20,
        },
      },
    }
  end
}
