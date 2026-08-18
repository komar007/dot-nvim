local utils = require("utils")

visible_bufnr = 0
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function(ev)
    if ev.event == "BufEnter" then
      visible_bufnr = ev.buf
    end
    if ev.event == "FileType" and ev.buf ~= visible_bufnr then
      return
    end
    local path = vim.api.nvim_buf_get_name(ev.buf)
    local title = "nvim"
    if path ~= "" then
      local filename = vim.fs.basename(path)
      title = title .. ":  " .. filename
    end
    title = title .. " in  " .. utils.shorten_path(vim.uv.cwd())
    vim.o.titlestring = title
  end
})
vim.opt.title = true
