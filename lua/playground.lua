local M = {}

local function open_playground(type, name)
  if name == "" then
    name = os.date("pg%Y%m%d")
  end
  local dir = vim.fn.expand('~/temp/' .. type .. '/' .. name);
  vim.fn.system({ "mkdir", "-p", dir })
  vim.fn.chdir(dir)
end

function M.make_playground(name, init)
  vim.api.nvim_create_user_command(name:gsub("^%l", string.upper) .. 'Playground', function(opts)
    open_playground(name, opts.args)
    local init_file = init()
    vim.api.nvim_cmd({ cmd = "edit", args = { init_file } }, { output = false })
  end, { nargs = '?' })
end

return M
