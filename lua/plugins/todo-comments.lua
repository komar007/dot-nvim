return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    keywords = {
      FIX = {
        icon = " ",
      },
    },
  },
  keys = {
    { "<leader>tt", "<cmd>TodoTrouble toggle<cr>", desc = "show Todo list in Trouble" }
  },
}
