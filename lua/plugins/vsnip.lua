return {
  'hrsh7th/vim-vsnip',
  config = function()
    local config_dir = vim.fn.stdpath("config")
    vim.g.vsnip_snippet_dir = config_dir .. "/snippets/"
  end,
}
