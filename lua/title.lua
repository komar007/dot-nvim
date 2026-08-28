local utils = require("utils")
local devicons = require('nvim-web-devicons')

local function strip_prefix(str, prefix)
  if str:sub(1, #prefix) == prefix then
    return str:sub(#prefix + 1)
  end
  return nil
end

local function basename(filename)
  if filename:sub(-1) == "/" then
    return vim.fs.basename(filename:sub(1, -2)) .. "/"
  else
    return vim.fs.basename(filename)
  end
end

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
    local is_oil = false
    if path ~= "" then
      local filename = strip_prefix(path, "oil://")
      if filename then
        is_oil = true
      else
        filename = path
      end

      filename = basename(filename)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
      local icon
      if is_oil then
        icon = "󰙅"
      elseif filetype == "man" then
        icon = ""
      else
        icon = devicons.get_icon_by_filetype(filetype) or ""
      end
      title = title .. ": " .. icon .. " " .. filename
    end
    title = title .. " in  " .. utils.shorten_path(vim.uv.cwd())
    vim.o.titlestring = title
  end
})
vim.opt.title = true
