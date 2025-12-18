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

    vim.cmd [[ hi DiffAdd guifg=NONE guibg=#071c04 guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffDelete guifg=#221111 guibg=#0c0300 guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffChange guifg=NONE guibg=#221505 guisp=#444444 gui=NONE ]]
    vim.cmd [[ hi DiffText guifg=NONE guibg=#663311 guisp=#444444 gui=NONE ]]

    -- used in GitGutterPreviewHunk
    vim.cmd [[ hi diffRemoved guifg=#bb1910 ]]
    vim.cmd [[ hi diffAdded guifg=#687b06 ]]

    vim.cmd [[ hi DiffviewDiffDeleteDim guifg=#1a1a1a guibg=#0a0a0a guisp=#444444 gui=NONE ]]
    -- DiffviewDiffAddAsDelete is set on diffview's init

    vim.cmd [[ hi FoldColumn guifg=#444488 guibg=#000000 ]]
    vim.cmd [[ hi Folded guifg=#888888 guibg=#171737 guisp=#5555aa gui=undercurl ]]

    vim.cmd [[ hi Normal guibg=NONE ]]
    vim.cmd [[ hi Comment guifg=#888888 ]]
    vim.cmd [[ hi CursorLine guibg=#2c2826 ]]
    vim.cmd [[ hi CursorColumn guibg=#2c2826 ]]
    vim.cmd [[ hi StatusLine guibg=#0a0a1a gui=NONE ]]
    vim.cmd [[ hi StatusLineNC guibg=#0a0a1a gui=NONE ]]
    vim.cmd [[ hi WinSeparator guifg=#222242 guibg=NONE ]]

    vim.cmd [[ hi Visual guifg=NONE guibg=#3333aa gui=NONE ]]

    set_highlight_nonfloat()
    vim.cmd [[ hi PmenuSel guifg=#ffffff ]]
    vim.cmd [[ hi FloatBorder guifg=#446699 guibg=NONE ]]
    vim.cmd [[ hi NormalFloat guifg=#777777 guibg=NONE ]]
    vim.cmd [[ hi FloatVisual guifg=NONE guibg=#4444bb gui=NONE ]]
    -- scrollbar in cmp/lsp
    vim.cmd [[ hi PmenuThumb guifg=NONE guibg=#446699 gui=NONE ]]

    vim.cmd [[ hi SnacksPickerDir guifg=#888888 ]]
    vim.cmd [[ hi SnacksPickerFile guifg=#dddddd gui=bold ]]
    vim.cmd [[ hi SnacksPickerBufFlags guifg=#888888 ]]
    vim.cmd [[ hi SnacksPickerMatch guifg=#fabd2f guisp=#fabd2f gui=underline ]]

    vim.cmd [[ hi SignColumn guibg=NONE ]]
    vim.cmd [[ hi GitSignsAdd guifg=#5faf5f ]]
    vim.cmd [[ hi GitSignsDelete guifg=#fb4934]]
    vim.cmd [[ hi GitSignsChange guifg=#fabd2f ]]
    vim.cmd [[ hi GitSignsChangedelete guifg=#ff5f00 ]]
    vim.cmd [[ hi GitSignsCurrentLineBlame guifg=#417fbf ]]

    vim.cmd [[ hi DiagnosticSignError guifg=#000000 guibg=#d75f5f gui=bold ]]
    vim.cmd [[ hi DiagnosticSignHint guifg=#3c3836 guibg=#8ec07c ]]
    vim.cmd [[ hi DiagnosticSignInfo guifg=#3c3836 guibg=#83a598 ]]
    vim.cmd [[ hi DiagnosticSignWarn guifg=#000000 guibg=#ca8462 gui=bold ]]

    vim.cmd [[ hi DiagnosticError guifg=#d75f5f ]]
    vim.cmd [[ hi DiagnosticHint guifg=#8ec07c ]]
    vim.cmd [[ hi DiagnosticInfo guifg=#83a598 ]]
    vim.cmd [[ hi DiagnosticWarn guifg=#ca8462 ]]

    vim.cmd [[ hi DiagnosticSignErrorLine guibg=#331106 ]]
    vim.cmd [[ hi DiagnosticSignHintLine guibg=#062201 ]]
    vim.cmd [[ hi DiagnosticSignWarnLine guibg=#332206 ]]

    vim.cmd [[ hi LspReferenceText gui=reverse,bold ]]
    vim.cmd [[ hi LspReferenceWrite guifg=#df4432 gui=reverse,bold ]]
    vim.cmd [[ hi LspReferenceRead guifg=#acaf26 gui=reverse,bold ]]

    vim.cmd [[ hi InlayHint guibg=#171717 guifg=#888888 ]]
    vim.cmd [[ hi LspCodeLens guifg=#555555 guibg=#111111 gui=italic,underdotted ]]
    vim.cmd [[ hi LspCodeLensSeparator guifg=#555555 gui=italic ]]

    vim.cmd [[ hi! link Pmenu Normal ]]

    vim.cmd [[ hi TreesitterContext guibg=#171737 ]]
    vim.cmd [[ hi TreesitterContextLineNumber guifg=#5555aa guibg=#171737 ]]
    vim.cmd [[ hi TreesitterContextBottom guisp=#5555aa gui=undercurl ]]

    vim.cmd [[ hi RenderMarkdownCode guibg=#151515 ]]

    vim.cmd [[ hi QuickFixLine guifg=NONE guibg=#3333aa gui=bold ]]

    vim.cmd [[ hi SatelliteBar guibg=#171737 ]]  -- this is affected by winblend...
    vim.cmd [[ hi SatelliteMark guifg=#6666a4 ]] -- ... while this is not
    vim.cmd [[ hi SatelliteSearch guifg=#ffff11 gui=bold ]]
    vim.cmd [[ hi SatelliteCursor guifg=#eeeeee ]]
    vim.cmd [[ hi SatelliteGitSignsAdd guifg=#2f5f2f guibg=NONE ]]
    vim.cmd [[ hi SatelliteGitSignsDelete guifg=#fb4934 guibg=NONE ]]
    vim.cmd [[ hi SatelliteGitSignsChange guifg=#7a4d1f guibg=NONE ]]
    vim.cmd [[ hi SatelliteDiagnosticError guifg=#ff0000 gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticHint guifg=#8ec07c gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticInfo guifg=#83a598 gui=bold ]]
    vim.cmd [[ hi SatelliteDiagnosticWarn guifg=#fa8462 gui=bold ]]

    vim.cmd [[ hi FidgetFloat guibg=NONE ]]

    vim.cmd [[ hi TabLine guifg=#555555 guibg=black ]]
    vim.cmd [[ hi TabLineFill guibg=black guisp=#333333 gui=underdotted ]]
    vim.cmd [[ hi TabLineSel guifg=#61afef guibg=terminal gui=bold ]]

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
