return {
  'airblade/vim-gitgutter',
  init = function()
    vim.opt.signcolumn = 'yes'
    vim.g.gitgutter_override_sign_column_highlight = 0
    vim.g.gitgutter_sign_added = "▍"
    vim.g.gitgutter_sign_removed = "◢"
    vim.g.gitgutter_sign_modified = "▍"
    vim.g.gitgutter_sign_modified_removed = "▍"
    vim.g.gitgutter_sign_removed_first_line = "◥"
    vim.g.gitgutter_eager = 1
    vim.g.gitgutter_realtime = 1
  end
}
