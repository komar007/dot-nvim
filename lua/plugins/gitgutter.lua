return {
  'airblade/vim-gitgutter',

  lazy = false,
  init = function()
    vim.g.gitgutter_signs = 0
    vim.g.gitgutter_floating_window_options = {
      col = 0,
      row = 0,
      width = 100,
      height = 20,
      relative = 'cursor',
      border = require('border').round,
      style = 'minimal',
    }
    vim.g.gitgutter_preview_win_floating = 1
  end,
  keys = {
    { "gc", "<Plug>(GitGutterPreviewHunk)" },
    { "<leader>gu", "<Plug>(GitGutterUndoHunk)" },
    { "<leader>gs", "<Plug>(GitGutterStageHunk)" },
  }
}
