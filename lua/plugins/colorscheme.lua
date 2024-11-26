local gruvbox = {
  'gruvbox-community/gruvbox',

  enabled = true,
  init = function()
    local utils = require('utils')

    local set_extra_whitespace = [[ highlight ExtraWhitespace ctermbg=red guibg=#ff7aa8 ]]
    local clear_extra_whitespace = [[ highlight clear ExtraWhitespace ]]

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
    vim.cmd [[ hi StatusLine gui=none guibg=#0a0a1a ]]
    vim.cmd [[ hi StatusLineNC gui=none guibg=#0a0a1a ]]
    vim.cmd [[ hi WinSeparator guifg=#222242 guibg=none ]]

    vim.cmd [[ hi Visual guibg=#3333aa guifg=none gui=none ]]

    vim.cmd(set_extra_whitespace)
    vim.cmd [[ hi PmenuSel guifg=#ffffff ctermfg=236 ]]
    vim.cmd [[ hi FloatBorder guibg=#000000 guifg=#446699 ]]
    vim.cmd [[ hi NormalFloat guibg=#000000 guifg=#777777 ]]
    vim.cmd [[ hi FloatVisual guibg=#4444bb guifg=none gui=none ]]
    -- scrollbar in cmp/lsp
    vim.cmd [[ hi PmenuThumb guibg=#446699 guifg=none gui=none ]]

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

    vim.cmd [[ hi InlayHint guibg='#171717' guifg='#888888' ]]
    vim.cmd [[ hi LspCodeLens guifg='#555555' gui=italic ]]
    vim.cmd [[ hi LspCodeLensSeparator guifg='#555555' gui=italic ]]

    vim.cmd [[ hi! link Pmenu Normal ]]

    vim.cmd [[ hi TreesitterContext guibg=#171737 ]]
    vim.cmd [[ hi TreesitterContextLineNumber guibg=#171737 guifg=#5555aa ]]
    vim.cmd [[ hi TreesitterContextBottom gui=undercurl guisp=#5555aa ]]

    vim.cmd [[ hi RenderMarkdownCode guibg=#151515 ]]

    utils.autocmd_all({ "ColorScheme" }, set_extra_whitespace)
    local match_extrawhitespace = [[ match ExtraWhitespace /\s\+$\|^\ [^*]?/ ]]
    utils.autocmd_all({ "BufWinEnter" }, match_extrawhitespace)
    vim.cmd(match_extrawhitespace)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = '*',
      callback = function()
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
        if is_floating then
          vim.cmd(clear_extra_whitespace)
        end
      end,
    })
    utils.autocmd_all({ "TermOpen", "TermEnter" }, clear_extra_whitespace)
    utils.autocmd_all({ "TermLeave", "TermClose", "BufWinLeave" }, set_extra_whitespace)
  end,
}

-- test
local osaka = {
  "craftzdog/solarized-osaka.nvim",

  enabled = false,
  lazy = false,
  opts = {},
  init = function()
    vim.cmd 'colorscheme solarized-osaka'
  end,
}

return { gruvbox, osaka }
