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
  {
    'lambdalisue/vim-suda',
    -- a very specific commit so that we cannot be compromised when someone hacks
    -- the repo and pushes malicious code to it
    commit = "b97fab52f9cdeabe2bbb5eb98d82356899f30829"
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
}
