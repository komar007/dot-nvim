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

return M
