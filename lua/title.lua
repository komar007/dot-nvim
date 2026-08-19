local utils = require("utils")

local ll_filetype = require('lualine.components.filetype'):new({
  colored = false,
  icons_enabled = true,
  icon_only = true,
  padding = 0
})

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
      local icon = ll_filetype:draw("", true)
      if icon == "" then
        icon = ""
      end
      title = title .. ": " .. icon .. " " .. filename
    end
    title = title .. " in  " .. utils.shorten_path(vim.uv.cwd())
    vim.o.titlestring = title
  end
})
vim.opt.title = true
