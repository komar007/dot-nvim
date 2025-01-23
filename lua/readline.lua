-- A little bit of emacs can't be too sacrilegious... right?
--
-- These are mainly for snacks inputs, which use insert mode for user input.
-- It's kind of hard for my brain to distinguish it from typing in shell, so I need some basic readline shortcuts.
-- Command line is handled by ryvnf/readline.vim.

local M = {}

local binds = {
  ['<C-a>'] = '<C-o>^',
  ['<C-e>'] = '<C-o>$',
  ['<C-b>'] = '<Left>',
  ['<C-f>'] = '<Right>',
  ['<C-d>'] = '<Delete>',
}

-- list of all key combos considered emacs-style (that should not be remapped)
M.keys = {}
for key, _ in pairs(binds) do
  table.insert(M.keys, key)
end
-- C-u already works as expected, so we list it as a readline bind, but without redefining
table.insert(M.keys, '<C-u>')

-- Set all emacs-style insert-mode binds
function M.set()
  for key, action in pairs(binds) do
    vim.keymap.set('i', key, action)
  end
end

return M
