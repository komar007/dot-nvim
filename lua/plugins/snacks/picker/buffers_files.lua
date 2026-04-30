M = {}

--- Picker config for buffers and files
---@param roots { path: string }[] Files under these LSP roots are ranked ahead of files outside the project roots.
---@return snacks.picker.Config
function M.for_roots(roots)
  local sort = require('snacks.picker.sort').default()
  return {
    matcher = {
      sort_empty = true,
    },
    sort = function(a, b)
      local a_in_root, b_in_root = false, false
      for _, root in ipairs(roots) do
        a_in_root = a_in_root or (a.file ~= nil and a._path:find(root.path, 1, true) == 1)
        b_in_root = b_in_root or (b.file ~= nil and b._path:find(root.path, 1, true) == 1)
      end
      if a_in_root and not b_in_root then
        return true
      end
      if b_in_root and not a_in_root then
        return false
      end
      return sort(a, b)
    end,
  }
end

return M
