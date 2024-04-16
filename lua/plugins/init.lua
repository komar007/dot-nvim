return {
  'ryvnf/readline.vim',
  'hynek/vim-python-pep8-indent',
  'rhysd/conflict-marker.vim',
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  'vim-scripts/a.vim',
  'bogado/file-line',
  'mzlogin/vim-markdown-toc',
  'HiPhish/rainbow-delimiters.nvim',
  {
    'inkarkat/vim-EnhancedJumps',
    dependencies = {
      'inkarkat/vim-ingo-library',
    },
    init = function()
      vim.g.EnhancedJumps_no_mappings = 1
    end,
    keys = {
      { "<Leader><C-o>", "<Plug>EnhancedJumpsRemoteOlder" },
      { "<Leader><C-i>", "<Plug>EnhancedJumpsRemoteNewer" },
    },
  },
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-w>h",    ":<C-U>TmuxNavigateLeft<cr>" },
      { "<C-w>j",    ":<C-U>TmuxNavigateDown<cr>" },
      { "<C-w>k",    ":<C-U>TmuxNavigateUp<cr>" },
      { "<C-w>l",    ":<C-U>TmuxNavigateRight<cr>" },
      { "<C-w><BS>", ":<C-U>TmuxNavigatePrevious<cr>" },
    }
  },
  'sotte/presenting.vim',
}
