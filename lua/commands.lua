vim.api.nvim_create_user_command('EditConfig', function()
  local config_dir = vim.fn.stdpath('config')
  assert(type(config_dir) == 'string', 'Expected string')
  vim.fn.chdir(config_dir)
  vim.api.nvim_cmd({ cmd = "edit", args = { "init.lua" } }, { output = false })
end, {})

local function linked_to(parent)
  local r = {}
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if hl.link == parent then
      table.insert(r, name)
    end
  end
  return r
end

vim.api.nvim_create_user_command('WhatLinksTo', function(ctx)
  local parent = ctx.args
  for _, linked in pairs(linked_to(parent)) do
    print(linked)
  end
end, { nargs = 1, complete = "highlight" })
