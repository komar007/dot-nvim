local M = {}

function M.autocmd_all(events, command)
  vim.api.nvim_create_autocmd(events, { pattern = "*", command = command })
end

local function codes(s)
  local r = {}
  local i = 1
  for x, _ in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    r[i] = x
    i = i + 1
  end
  return r
end

local function map(x, f)
  local o = {}
  for k, v in pairs(x) do
    o[k] = f(v)
  end
  return o
end

local function border_map(x)
  return {
    x[1][1],
    x[1][2],
    x[1][3],
    x[2][3],
    x[3][3],
    x[3][2],
    x[3][1],
    x[2][1],
  }
end

local function zip(a, b)
  local o = {}
  for k, v in pairs(a) do
    o[k] = { v, b[k] }
  end
  return o
end

function M.make_border(spec)
  local spec_border = spec[1]
  local spec_hi = spec[2]
  local spec_hi_name = spec[3]
  local b = border_map(map({ 1, 2, 3 }, function(i)
    return codes(spec_border[i])
  end))
  local hi = map(border_map(spec_hi), function(h) return spec_hi_name[h] end)
  return zip(b, hi)
end

function M.initialize_file(name, content)
  if io.open(name, "r") == nil then
    local file = io.open(name, "w")
    assert(file ~= nil)
    file:write(content)
    file:close()
  end
end

function M.setup_lsps(base_cfg, lsps)
  local lspconfig = require('lspconfig')
  for _, lsp in pairs(lsps) do
    local lsp_name
    if type(lsp) == "table" then
      lsp_name = lsp[1]
      table.remove(lsp, 1)
      for k, v in pairs(base_cfg) do
        if lsp[k] == nil then
          lsp[k] = v
        end
      end
    else
      lsp_name = lsp
      lsp = base_cfg
    end
    lspconfig[lsp_name].setup(lsp)
  end
end

function M.shorten_path(path)
  local home = os.getenv("HOME")
  if path:sub(1, #home) == home then
    path = "~" .. path:sub(#home + 1)
  end
  return path
end

function M.keys_with_alternate(keys)
  local alt = {
    ["<C-S-y>"] = "<Char-0xE105>",
    ["<C-S-p>"] = "<Char-0xE106>",
    ["<C-S-n>"] = "<Char-0xE107>",
  }
  local out = {}
  for key, action in pairs(keys) do
    out[key] = action
    if alt[key] ~= nil then
      out[alt[key]] = action
    end
  end
  return out
end

function M.define_text_object(object, motion)
  vim.keymap.set({ 'x', 'o' }, object, function()
    vim.cmd('normal! ' .. motion)
  end, { noremap = true, silent = true })
end

function M.define_text_object_inside_around(char)
  M.define_text_object("i" .. char, "T" .. char .. "vt" .. char)
  M.define_text_object("a" .. char, "F" .. char .. "vf" .. char)
end

function M.on_ft(ft, callback)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = callback,
    group = "FileTypeSettings",
  })
end

return M
