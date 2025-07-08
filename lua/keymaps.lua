vim.keymap.set('n', '<F2>', function() vim.o.cursorcolumn = not vim.o.cursorcolumn end, { expr = true })

-- Remove both the character under the cursor and its match
vim.keymap.set('n', '<leader>x', function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = string.sub(vim.api.nvim_get_current_line(), col + 1, col + 1)
  if string.find([[ ([< ]], char, 1, true) then
    vim.api.nvim_feedkeys("mm%x`mx", 'n', true)
  elseif string.find([[ )]> ]], char, 1, true) then
    vim.api.nvim_feedkeys("%mm%x`mx", 'n', true)
  end
end)

vim.keymap.set('n', '<leader>y', function()
  vim.api.nvim_feedkeys([[mY"*yiw`Y]], 'n', true)
end, { noremap = true })

local utils = require('utils')

utils.define_text_object_inside_around('/')
utils.define_text_object_inside_around('.')
