local M = {}
local utils = require('utils')

M.round = utils.make_border {
  {
    '╭─╮',
    '│ │',
    '╰─╯',
  },
  {
    { 'n', 'n', 'n' },
    { 'n', nil, 'n' },
    { 'n', 'n', 'n' },
  },
  {
    n = 'FloatBorder',
  }
}

M.fidget = utils.make_border {
  {
    '│  ',
    '│  ',
    '   ',
  },
  {
    { 'n', 'n', 'n' },
    { 'n', nil, 'n' },
    { 'n', 'n', 'n' },
  },
  {
    n = 'FloatBorder',
  }
}

return M
