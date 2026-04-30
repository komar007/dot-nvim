local M = {}

local utils = require('utils')

local function wrap_one_based(idx, n)
  return (idx - 1) % n + 1
end

--- Build a snacks picker action which closes the current picker and opens an alternative one from
--- the group of alternatives, maintaining the input pattern.
---
--- The first group where the current picker is found is used as the group of alternatives. The next
--- item from the group is always selected. When the current picker is the last in the group, the
--- first picker from the group is selected.
---@param alternatives_spec string[][]|{source: string, reuse_opts: string[]}[][]
function M.make_alternate_picker_action(alternatives_spec)
  local alternatives = utils.map2(alternatives_spec, function(item)
    if type(item) == "table" then
      return item
    elseif type(item) == "string" then
      return { source = item, reuse_opts = {} }
    else
      error("bad picker alternative spec")
    end
  end)
  ---@param current_picker snacks.Picker
  return function(current_picker)
    local alt_picker = nil
    for _, group in ipairs(alternatives) do
      for i, alt in ipairs(group) do
        if current_picker.opts.source == alt.source then
          alt_picker = group[wrap_one_based(i + 1, #group)]
          goto end_search
        end
      end
    end
    ::end_search::
    if alt_picker == nil then
      return
    end
    local new_opts = {
      show_empty = true, -- so that the cycle is not broken by some of the pickers never appearing
      pattern = current_picker:filter().pattern,
      search = current_picker:filter().search,
      live = current_picker.opts.live,
    }
    for _, opt in ipairs(alt_picker.reuse_opts) do
      new_opts[opt] = current_picker.opts[opt]
    end
    current_picker:close()
    require 'snacks'.picker(alt_picker.source, new_opts)
  end
end

return M
