local gruvbox = {
  'gruvbox-community/gruvbox',

  enabled = true,
  init = function()
    local utils = require('utils')

    local function set_highlight_nonfloat()
      vim.cmd [[ hi ExtraWhitespace guibg=#ff7aa8 ]]
      vim.cmd [[ hi PastTextWidth guibg=#6c1a28 ]]
    end
    local function clear_highlight_nonfloat()
      vim.cmd [[ hi clear ExtraWhitespace ]]
      vim.cmd [[ hi clear PastTextWidth ]]
    end

    vim.opt.termguicolors = true
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.gruvbox_italicize_comments = 1
    vim.g.gruvbox_underline = 1
    vim.g.gruvbox_italic = 1
    vim.cmd 'colorscheme gruvbox'
    vim.opt.background = 'dark'

    vim.cmd [[ hi DiffAdd guibg=#071c04 guifg=NONE guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffDelete guibg=#0c0300 guifg=#221111 guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffChange guibg=#221505 guifg=NONE guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffText guibg=#663311 guifg=NONE guisp=#444444 gui=NONE ]]

    -- used in GitGutterPreviewHunk
    vim.cmd [[ hi diffRemoved guifg=#bb1910 ]]
    vim.cmd [[ hi diffAdded guifg=#687b06 ]]

    vim.cmd [[ hi DiffviewDiffDeleteDim guibg=#0a0a0a guifg=#1a1a1a guisp=#444444 gui=NONE ]]
    -- DiffviewDiffAddAsDelete is set on diffview's init

    vim.cmd [[ hi FoldColumn guibg=#000000 guifg=#444488 ]]
    vim.cmd [[ hi Folded guibg=#171737 guifg=#888888 guisp=#5555aa gui=undercurl ]]

    vim.cmd [[ hi Normal ctermbg=16 guibg=none ]]
    vim.cmd [[ hi Comment ctermfg=243 guifg=#888888 ]]
    vim.cmd [[ hi CursorLine ctermbg=237 guibg=#2c2826 ]]
    vim.cmd [[ hi CursorColumn ctermbg=237 guibg=#2c2826 ]]
    vim.cmd [[ hi StatusLine gui=none guibg=#0a0a1a ]]
    vim.cmd [[ hi StatusLineNC gui=none guibg=#0a0a1a ]]
    vim.cmd [[ hi WinSeparator guifg=#222242 guibg=none ]]

    vim.cmd [[ hi Visual guibg=#3333aa guifg=none gui=none ]]

    set_highlight_nonfloat()
    vim.cmd [[ hi PmenuSel guifg=#ffffff ctermfg=236 ]]
    vim.cmd [[ hi FloatBorder guibg=none guifg=#446699 ]]
    vim.cmd [[ hi NormalFloat guibg=none guifg=#777777 ]]
    vim.cmd [[ hi FloatVisual guibg=#4444bb guifg=none gui=none ]]
    -- scrollbar in cmp/lsp
    vim.cmd [[ hi PmenuThumb guibg=#446699 guifg=none gui=none ]]

    vim.cmd [[ hi SnacksPickerDir guifg=#888888 ]]
    vim.cmd [[ hi SnacksPickerFile guifg=#dddddd gui=bold ]]
    vim.cmd [[ hi SnacksPickerBufFlags guifg=#888888 ]]
    vim.cmd [[ hi SnacksPickerMatch guifg=#fabd2f gui=underline guisp=#fabd2f ]]

    vim.cmd [[ hi SignColumn guibg=none ]]
    vim.cmd [[ hi GitSignsAdd guifg=#5faf5f ]]
    vim.cmd [[ hi GitSignsDelete guifg=#fb4934]]
    vim.cmd [[ hi GitSignsChange guifg=#FABD2F ]]
    vim.cmd [[ hi GitSignsChangedelete guifg=#ff5f00 ]]
    vim.cmd [[ hi GitSignsCurrentLineBlame guifg=#417fbf ]]

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
    vim.cmd [[ hi LspCodeLens guifg='#555555' guibg='#111111' gui=italic,underdotted ]]
    vim.cmd [[ hi LspCodeLensSeparator guifg='#555555' gui=italic ]]

    vim.cmd [[ hi! link Pmenu Normal ]]

    vim.cmd [[ hi TreesitterContext guibg=#171737 ]]
    vim.cmd [[ hi TreesitterContextLineNumber guibg=#171737 guifg=#5555aa ]]
    vim.cmd [[ hi TreesitterContextBottom gui=undercurl guisp=#5555aa ]]

    vim.cmd [[ hi RenderMarkdownCode guibg=#151515 ]]

    vim.cmd [[ hi QuickFixLine guibg=#3333aa guifg=none gui=bold ]]

    vim.cmd [[ hi SatelliteBar guibg=#171737 ]] -- this is affected by winblend...
    vim.cmd [[ hi SatelliteMark guifg=#6666a4 ]] -- ... while this is not
    vim.cmd [[ hi SatelliteSearch guifg=#ffff11 gui=bold ]]
    vim.cmd [[ hi SatelliteCursor guifg=#eeeeee ]]
    vim.cmd [[ hi SatelliteGitSignsAdd guibg=none guifg=#2f5f2f ]]
    vim.cmd [[ hi SatelliteGitSignsDelete guibg=none guifg=#fb4934 ]]
    vim.cmd [[ hi SatelliteGitSignsChange guibg=none guifg=#7a4d1f ]]
    vim.cmd [[ hi SatelliteDiagnosticError guifg=#ff0000 gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticHint guifg=#8ec07c gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticInfo guifg=#83a598 gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticWarn guifg=#fa8462 gui=bold ]]

    vim.cmd [[ hi FidgetFloat guibg=none ]]

    vim.cmd [[ hi TabLine guibg=black guifg=#555555 ]]
    vim.cmd [[ hi TabLineFill guibg=black gui=underdotted guisp=#333333 ]]
    vim.cmd [[ hi TabLineSel guibg=terminal guifg=#61afef gui=bold ]]

    utils.autocmd_all({ "ColorScheme" }, set_highlight_nonfloat)
    local function match_extrawhitespace()
      vim.cmd [[ match ExtraWhitespace /\s\+$\|^\ [^*]?/ ]]
    end
    utils.autocmd_all({ "BufWinEnter" }, match_extrawhitespace)
    match_extrawhitespace()
    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = '*',
      callback = function()
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
        if is_floating then
          clear_highlight_nonfloat()
        end
      end,
    })
    utils.autocmd_all({ "TermOpen", "TermEnter" }, clear_highlight_nonfloat)
    utils.autocmd_all({ "TermLeave", "TermClose", "BufWinLeave" }, set_highlight_nonfloat)
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
