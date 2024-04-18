local M = {}

local cmp = require("cmp")
local timer = vim.loop.new_timer()

function M.debounce()
  timer:stop()
  timer:start(
    vim.opt.updatetime:get(),
    0,
    vim.schedule_wrap(function()
      cmp.complete({ reason = cmp.ContextReason.Auto })
    end)
  )
end

return M
