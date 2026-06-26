return {
  "spacedentist/resolve.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    default_keymaps = false,
    on_conflict_detected = function(info)
      vim.keymap.set("n", "gz", "<Plug>(resolve-diff-both)", { buffer = info.bufnr })
      vim.keymap.set("n", "]x", "<Plug>(resolve-next)", { buffer = info.bufnr, desc = "Next conflict" })
      vim.keymap.set("n", "[x", "<Plug>(resolve-prev)", { buffer = info.bufnr, desc = "Previous conflict" })
    end,
    on_conflicts_resolved = function(info)
      pcall(vim.keymap.del, "n", "gz", { buffer = true })
      pcall(vim.keymap.del, "n", "]x", { buffer = true })
      pcall(vim.keymap.del, "n", "[x", { buffer = true })
    end,
  },
}
