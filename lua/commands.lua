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

vim.api.nvim_create_user_command('InlayHintsToggle', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { nargs = 0 })

vim.api.nvim_create_user_command("TmuxUpdateEnvironment", function()
  local result = vim.system({ "tmux", "show-environment" }, { text = true }):wait()
  if result.code ~= 0 then
    local stderr = vim.trim(result.stderr or "")
    if stderr == "" then
      vim.notify("tmux show-environment failed", vim.log.levels.ERROR)
    else
      vim.notify(
        string.format("Could not update tmux environment: \"%s\"", stderr),
        vim.log.levels.ERROR
      )
    end
    return
  end

  local updated = {}

  for _, line in ipairs(vim.split(result.stdout or "", "\n", { trimempty = true })) do
    if vim.startswith(line, "-") then
      local env = line:sub(2)
      if vim.env[env] ~= nil then
        table.insert(updated, { env, from = vim.env[env] })
      end
      vim.env[env] = nil
    else
      local eq = line:find("=", 1, true)
      if eq ~= nil then
        local env = line:sub(1, eq - 1)
        local val = line:sub(eq + 1)
        if vim.env[env] ~= val then
          table.insert(updated, { env, from = vim.env[env], to = val })
        end
        vim.env[env] = val
      end
    end
  end

  if #updated == 0 then
    vim.notify("Nothing to update from tmux", vim.log.levels.INFO)
  else
    local msg = ""
    for _, update in ipairs(updated) do
      if update.from == nil then
        msg = msg .. string.format("%s = \"%s\"\n", update[1], update.to)
      elseif update.to == nil then
        msg = msg .. string.format("%s = ❌\n", update[1], update.to)
      else
        msg = msg .. string.format("%s = \"%s\" ➡ \"%s\"\n", update[1], update.from, update.to)
      end
    end
    vim.notify(string.format("Updated environment from tmux:\n%s", msg), vim.log.levels.INFO)
  end
end, { nargs = 0 })
