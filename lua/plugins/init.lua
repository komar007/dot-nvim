return {
  'HiPhish/rainbow-delimiters.nvim',
  'bogado/file-line',
  'hynek/vim-python-pep8-indent',
  'mzlogin/vim-markdown-toc',
  'rhysd/conflict-marker.vim',
  'ryvnf/readline.vim',
  'sotte/presenting.vim',
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  'vim-scripts/a.vim',
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
  },
  -- a very specific commit so that we cannot be compromised when someone hacks
  -- the repo and pushes malicious code to it
  { 'lambdalisue/vim-suda', commit = "b97fab52f9cdeabe2bbb5eb98d82356899f30829" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_browser = "firefox"
    end,
    ft = { "markdown" },
  },
}
