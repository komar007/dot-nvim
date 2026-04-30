local utils = require('utils')

return {
  actions = {
    yank_add = { action = "yank", reg = '"', field = "added_lines" },
    yank_del = { action = "yank", reg = '"', field = "removed_lines" },
  },
  win = {
    input = {
      keys = utils.keys_with_alternate {
        ["<C-y>"] = { "yank_add", mode = { "n", "i" } },
        ["<C-S-y>"] = { "yank_del", mode = { "n", "i" } },
      },
    },
  },
  layout = {
    fullscreen = true,
    preset = "default",
    cycle = false
  }
}
