return {
  "sug44/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>a", function() require('harpoon'):list():add() end },
    { "<leader>A", function() require('harpoon'):list():remove() end },
    { "<C-g>",     function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
    { "<M-j>",     function() require('harpoon'):list():select(1) end },
    { "<M-k>",     function() require('harpoon'):list():select(2) end },
    { "<M-l>",     function() require('harpoon'):list():select(3) end },
    { "<M-;>",     function() require('harpoon'):list():select(4) end },
  },
}
