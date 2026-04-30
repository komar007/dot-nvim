local git = require('snacks.picker.source.git')

---@type snacks.picker.Config
return {
  matcher = {
    sort_empty = true,
  },
  sort = function(a, b)
    local a_unmerged = git.git_status(a.status).unmerged or false
    local b_unmerged = git.git_status(b.status).unmerged or false
    if a_unmerged ~= b_unmerged then
      return a_unmerged and not b_unmerged
    end
    return a.idx < b.idx
  end,
}
