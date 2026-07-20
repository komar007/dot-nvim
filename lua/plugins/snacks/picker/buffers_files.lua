M = {}

--- Obtain the length of root if it is the root of snacks.picker.sort compare item, -1 otherwise
---
--- This metric is greater for file items in the specified root than for items outside of the root,
--- also, it is greater for longer root paths. Longer root paths are preferred, as it is assumed
--- that a single file will only be tested against a list of roots generated from another file,
--- which are each other's prefixes, in a certain order. Using the maximum of this metric for a file
--- over all tested roots as a sorting key establishes a partial order that prefers more deeply
--- nested roots over less deeply nested roots over no roots at all (files outside of any expected
--- roots).
---@param item snacks.picker.Item
---@param root string
local function root_len(item, root)
  if item.file ~= nil and item._path:find(root, 1, true) == 1 then
    return string.len(root)
  else
    return -1
  end
end

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
      local a_max_root, b_max_root = -1, -1
      for _, root in ipairs(roots) do
        a_max_root = math.max(a_max_root, root_len(a, root.path))
        b_max_root = math.max(b_max_root, root_len(b, root.path))
      end
      if a_max_root > b_max_root then
        return true
      end
      if a_max_root < b_max_root then
        return false
      end
      return sort(a, b)
    end,
  }
end

return M
