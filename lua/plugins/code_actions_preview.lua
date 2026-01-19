return {
  "rachartier/tiny-code-action.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "komar007/snacks.nvim",
  },
  event = "LspAttach",
  opts = {
    backend = "delta",
    picker = {
      "snacks",
      opts = {
        layout = { preset = "ivy" },
      },
    },
  },
  keys = {
    { "ga", function() require("tiny-code-action").code_action() end, mode = { "v", "n" } },
  },
}
