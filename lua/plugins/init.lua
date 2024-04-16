return {
  'ryvnf/readline.vim',
  'hynek/vim-python-pep8-indent',
  'rhysd/conflict-marker.vim',
  'vim-scripts/cscope_macros.vim',
  'tpope/vim-fugitive',
  'cloudhead/neovim-fuzzy',
  'tpope/vim-sleuth',
  'vim-scripts/a.vim',
  'bogado/file-line',
  'vim-scripts/camelcasemotion',
  'mzlogin/vim-markdown-toc',
  'pangloss/vim-javascript',
  'maxmellon/vim-jsx-pretty',
  'HiPhish/rainbow-delimiters.nvim',
  'rust-lang/rust.vim',
  'inkarkat/vim-ingo-library', -- required by inkarkat/vim-EnhancedJumps
  {
    'inkarkat/vim-EnhancedJumps',
    init = function()
      vim.g.EnhancedJumps_no_mappings = 1
    end,
    keys = {
      { "<Leader><C-o>", "<Plug>EnhancedJumpsRemoteOlder" },
      { "<Leader><C-i>", "<Plug>EnhancedJumpsRemoteNewer" },
    },
  },
  'sotte/presenting.vim',
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
  }
}
