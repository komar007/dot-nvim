local M = {}

function M.autocmd_all(events, command)
  vim.api.nvim_create_autocmd(events, { pattern = "*", command = command })
end

return M
