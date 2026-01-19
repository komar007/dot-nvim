return {
  "aznhe21/actions-preview.nvim",

  dependencies = {
    "komar007/snacks.nvim",
  },
  lazy = false,
  opts = function()
    return {
      snacks = {
        layout = { preset = "ivy" },
      },
      highlight_command = {
        require("actions-preview.highlight").delta(),
      },
    }
  end,
  keys = {
    { "ga", function() require("actions-preview").code_actions() end, mode = { "v", "n" } },
  },
}
