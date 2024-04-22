return {
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
}
