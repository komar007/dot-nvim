vim.api.nvim_set_hl(0, 'IblIndent', { ctermfg = 237, fg = '#3a3a3a' })

require("ibl").setup {
  indent = { char = '┆' },
  scope = { char = '│', show_start = false, show_end = false },
}
