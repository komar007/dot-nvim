return {
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
