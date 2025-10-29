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
          enabled = true,
          max_results = 20,
          min_chars = 3,
        }
      },
    }
  end
}
