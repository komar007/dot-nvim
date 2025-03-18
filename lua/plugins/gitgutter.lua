return {
  'airblade/vim-gitgutter',

  lazy = false,
  init = function()
    vim.opt.signcolumn = 'yes'
    vim.g.gitgutter_override_sign_column_highlight = 0
    vim.g.gitgutter_sign_added = "▍"
    vim.g.gitgutter_sign_removed = "▁"
    vim.g.gitgutter_sign_modified = "▍"
    vim.g.gitgutter_sign_modified_removed = "▍"
    vim.g.gitgutter_sign_removed_first_line = "◥"
    vim.g.gitgutter_eager = 1
    vim.g.gitgutter_realtime = 1
    vim.g.gitgutter_floating_window_options = {
      col = 0,
      row = 0,
      width = 100,
      height = 20,
      relative = 'cursor',
      border = require('border'),
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
