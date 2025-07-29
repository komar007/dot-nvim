local ns = vim.api.nvim_create_namespace("past_text_width_highlight")

local function update_colorcolumn()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  local col = vim.o.textwidth
  if col == 0 then return end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_line_count(0)

  for l = 1, lines do
    if l < cursor[1] - 1 or l > cursor[1] + 1 then
      vim.api.nvim_buf_add_highlight(0, ns, "PastTextWidth", l - 1, col, -1)
    end
  end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter" }, {
  callback = update_colorcolumn,
})
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "textwidth",
  callback = update_colorcolumn,
})
