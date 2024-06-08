local utils = require('utils')

return utils.make_border {
  {
    --'▁▁▁',
    --'▏ ▕',
    --'▔▔▔',
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
