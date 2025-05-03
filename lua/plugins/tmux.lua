return {
  --'christoomey/vim-tmux-navigator',
  -- temporarily using a local fork with #396 fixed and a new feature #439.
  'komar007/vim-tmux-navigator',

  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_preserve_zoom = 1
    vim.g.tmux_navigator_no_wrap = 1
    vim.g.tmux_navigator_no_wrap_disable_when_zoomed = 1
  end,
  keys = {
    { "<C-w><BS>",         "<C-w><C-p>",                          mode = { 'n' } },
    { "<Char-0xE120>h",    "<C-o>:<C-U>TmuxNavigateLeft<cr>",     mode = { 'i' } },
    { "<Char-0xE120>j",    "<C-o>:<C-U>TmuxNavigateDown<cr>",     mode = { 'i' } },
    { "<Char-0xE120>k",    "<C-o>:<C-U>TmuxNavigateUp<cr>",       mode = { 'i' } },
    { "<Char-0xE120>l",    "<C-o>:<C-U>TmuxNavigateRight<cr>",    mode = { 'i' } },
    { "<Char-0xE120><BS>", "<C-o>:<C-U>TmuxNavigatePrevious<cr>", mode = { 'i' } },
    { "<Char-0xE120>h",    ":<C-U>TmuxNavigateLeft<cr>",          mode = { 'n' } },
    { "<Char-0xE120>j",    ":<C-U>TmuxNavigateDown<cr>",          mode = { 'n' } },
    { "<Char-0xE120>k",    ":<C-U>TmuxNavigateUp<cr>",            mode = { 'n' } },
    { "<Char-0xE120>l",    ":<C-U>TmuxNavigateRight<cr>",         mode = { 'n' } },
    { "<Char-0xE120><BS>", ":<C-U>TmuxNavigatePrevious<cr>",      mode = { 'n' } },
  }
}
