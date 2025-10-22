return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local config_dir = vim.fn.stdpath("config")
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = {
        config_dir .. "/snippets/"
      }
    })
  end,
  keys = {
    {
      "<Tab>",
      function()
        local ls = require('luasnip')
        if ls.jumpable(1) then
          ls.jump(1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
        end
      end,
      mode = { "i", "s" }
    },
    { "<S-Tab>", function() require('luasnip').jump(-1) end, mode = { "i", "s" } },
  },
}
