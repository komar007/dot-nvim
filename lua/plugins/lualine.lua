local colors = {
  black    = '#111111',
  bg_outer = '#222242',
  bg_mid   = '#171737',
  bg_inner = '#0a0a1a',
  fg       = '#bbc2cf',
  darkfg   = '#6b727f',
  green    = '#98be65',
  green_i  = '#587e45',
  orange   = '#fe8019',
  violet   = '#8981c1',
  visual   = '#3333aa',
  visual_f = '#bbbbff',
  red      = '#fb4934',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local theme = {
  normal = {
    a = { fg = colors.fg, bg = colors.bg_outer },
    b = { fg = colors.fg, bg = colors.bg_mid },
    c = { fg = colors.darkfg, bg = colors.bg_inner },
    x = { fg = colors.darkfg, bg = colors.bg_inner },
    y = { fg = colors.darkfg, bg = colors.bg_mid },
    z = { fg = colors.darkfg, bg = colors.bg_outer },
  },
  insert = { a = { fg = colors.black, bg = colors.green_i } },
  visual = { a = { fg = colors.visual_f, bg = colors.visual } },
  replace = { a = { fg = colors.black, bg = colors.violet } },
}

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return ' ' .. last_search .. ' (' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local colored_filename = require('lualine_colored_filename').colored_filename
    require('lualine').setup {
      options = {
        theme = theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            function ()
              return '  '
            end,
            padding = 0,
            color = { fg = '#67a23e' },
          },
          {
            'branch',
            icon = '⎇',
          },
          {
            'diff',
            symbols = { added = '󰐖 ', modified = '󱗜 ', removed = '󰍵 ' },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            on_click = function(_, but, _)
              if but == 'l' then
                vim.api.nvim_command('GitGutterNextHunk')
              elseif but == 'r' then
                vim.api.nvim_command('GitGutterPrevHunk')
              end
            end,
          },
        },
        lualine_b = {
          {
            colored_filename,
            file_status = true,
            path = 1,
            symbols = {
              modified = '󰧞',
              readonly = '',
            },
          },
          {
            '%w',
            cond = function()
              return vim.wo.previewwindow
            end,
          },
          {
            '%q',
            cond = function()
              return vim.bo.buftype == 'quickfix'
            end,
          },
          {
            '%l:%c',
            color = { fg = colors.fg },
          },
        },
        lualine_c = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = '󰧞', warn = '󰧞', info = '󰧞', hint = '󰧞' },
            diagnostics_color = {
              -- TODO: extract the colors below, they should be the same as those used in respective diagnostics
              error = { fg = '#d75f5f' },
              warn = { fg = '#ca8462' },
              info = { fg = '#ecbe7b' },
              hint = { fg = '#83a598' },
            },
            on_click = function(_, but, _)
              if but == 'l' then
                vim.diagnostic.goto_next();
              elseif but == 'r' then
                vim.diagnostic.goto_prev();
              end
            end,
          },
        },
        lualine_x = {
          {
            search_result,
          },
        },
        lualine_y = {
          {
            'filetype',
          },
          {
            'o:encoding',
            cond = conditions.hide_in_width,
          },
          {
            'fileformat',
            icons_enabled = true,
            cond = conditions.hide_in_width,
            padding = 1,
          },
        },
        lualine_z = {
          {
            '%p%%/%L',
          },
        },
      },
      inactive_sections = {
      },
    }
  end,
}
