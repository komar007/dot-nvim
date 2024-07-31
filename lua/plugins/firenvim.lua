return {
  'glacambre/firenvim',

  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  init = function()
    vim.g.firenvim_config = {
      globalSettings = { alt = "all" },
      localSettings = {
        [".*"] = {
          cmdline  = "neovim",
          content  = "text",
          priority = 0,
          selector = "textarea",
          takeover = "never"
        }
      }
    }
  end,
  config = function()
    vim.api.nvim_create_autocmd({ 'UIEnter' }, {
      callback = function(_)
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client ~= nil and client.name == "Firenvim" then
          vim.cmd [[ set gfn=Jetbrains\ Mono\ Light:h9 ]]
          vim.cmd [[ set linespace=-4 ]]
          vim.cmd [[ command Maximize set lines=1000 columns=1000 ]]
          vim.o.laststatus = 0
        end
      end
    })
  end
}
