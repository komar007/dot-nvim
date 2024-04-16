return {
  'gruvbox-community/gruvbox',
  init = function()
    local utils = require('utils')

    vim.opt.termguicolors = true
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.gruvbox_italicize_comments = 1
    vim.g.gruvbox_underline = 1
    vim.g.gruvbox_italic = 1
    vim.cmd 'colorscheme gruvbox'
    vim.opt.background = 'dark'

    vim.cmd [[ hi Normal ctermbg=16 guibg=#000000 ]]
    vim.cmd [[ hi Comment ctermfg=243 guifg=#7f7f7f ]]
    vim.cmd [[ hi CursorLine ctermbg=237 guibg=#2c2826 ]]
    vim.cmd [[ hi CursorColumn ctermbg=237 guibg=#2c2826 ]]
    vim.cmd [[ hi! link StatusLine Normal ]]
    vim.cmd [[ hi! link StatusLineNC Normal ]]

    vim.cmd [[ hi ExtraWhitespace ctermbg=red guibg=#902020 ]]
    vim.cmd [[ hi PmenuSel guifg=#ffffff ctermfg=236 ]]

    vim.cmd [[ hi SignColumn guibg='#000000' ctermbg=16 ]]
    vim.cmd [[ hi GitGutterAdd ctermfg=71 guifg=#5FAF5F ]]
    vim.cmd [[ hi GitGutterDelete ctermbg=16 guibg='#000000' ]]
    vim.cmd [[ hi GitGutterChange ctermfg=214 guifg=#FABD2F ]]
    vim.cmd [[ hi GitGutterChangeDelete ctermfg=202 guifg=#ff5f00 ]]

    vim.cmd [[ hi DiagnosticSignError guifg='#000000' guibg='#d75f5f' ctermfg=237 ctermbg=167 gui=bold ]]
    vim.cmd [[ hi DiagnosticSignHint guifg='#3c3836' guibg='#8ec07c' ctermfg=237 ctermbg=108 ]]
    vim.cmd [[ hi DiagnosticSignInfo guifg='#3c3836' guibg='#83a598' ctermfg=237 ctermbg=109 ]]
    vim.cmd [[ hi DiagnosticSignWarn guifg='#000000' guibg='#ca8462' ctermfg=16 ctermbg=136 gui=bold ]]

    vim.cmd [[ hi DiagnosticError guifg='#d75f5f' ctermfg=167 ]]
    vim.cmd [[ hi DiagnosticHint guifg='#8ec07c' ctermfg=108 ]]
    vim.cmd [[ hi DiagnosticInfo guifg='#83a598' ctermfg=109 ]]
    vim.cmd [[ hi DiagnosticWarn guifg='#ca8462' ctermfg=136 ]]

    vim.cmd [[ hi DiagnosticSignErrorLine guibg='#331106' ]]
    vim.cmd [[ hi DiagnosticSignHintLine guibg='#062201' ]]
    vim.cmd [[ hi DiagnosticSignWarnLine guibg='#332206' ]]

    vim.cmd [[ hi LspReferenceText gui=reverse,bold cterm=reverse,bold ]]
    vim.cmd [[ hi LspReferenceWrite guifg='#df4432' ctermfg=red gui=reverse,bold cterm=reverse,bold ]]
    vim.cmd [[ hi LspReferenceRead guifg='#acaf26' ctermfg=green gui=reverse,bold cterm=reverse,bold ]]

    vim.cmd [[ hi InlayHint guibg='#171717' guifg='#666666' ]]

    vim.cmd [[ hi! link Pmenu Normal ]]

    utils.autocmd_all({ "ColorScheme" }, [[ highlight ExtraWhitespace ctermbg=red guibg=#902020 ]])
    local match_extrawhitespace = [[ match ExtraWhitespace /\s\+$\|^\ [^*]?/ ]]
    utils.autocmd_all({ "BufWinEnter" }, match_extrawhitespace)
    vim.cmd(match_extrawhitespace)
    utils.autocmd_all({ "TermOpen", "TermEnter" }, [[ highlight clear ExtraWhitespace ]])
    utils.autocmd_all({ "TermLeave", "TermClose" }, [[ highlight ExtraWhitespace ctermbg=red guibg=#902020 ]])
  end,
}
