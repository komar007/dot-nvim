vim.api.nvim_create_user_command('LazyHeadless', function(opts)
  local lazy_cmd_name = opts.fargs[1]
  if lazy_cmd_name == nil then
    vim.api.nvim_echo({
      { "ERROR: " .. "no command given\n", "ErrorMsg" },
    }, true, {})
    os.exit(2)
  end
  local lazy_cmd = require("lazy")[lazy_cmd_name]
  table.remove(opts.fargs, 1)
  if #opts.fargs == 0 then
    opts.fargs = nil
  end

  local ok, error = pcall(lazy_cmd, {
    wait = true,
    show = false,
    plugins = opts.fargs,
  })
  if ok then
    os.exit(0)
  else
    vim.api.nvim_echo({
      { "LAZY ERROR: " .. error .. "\n", "ErrorMsg" },
    }, true, {})
    os.exit(1)
  end
end, { nargs = "*" })
