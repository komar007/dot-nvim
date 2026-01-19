return {
  "aznhe21/actions-preview.nvim",

  dependencies = {
    "komar007/snacks.nvim",
  },
  lazy = false,
  opts = {
    snacks = {
      layout = { preset = "ivy" },
    },
  },
  keys = {
    { "ga", function() require("actions-preview").code_actions() end, mode = { "v", "n" } },
  },
}
