return {
  "spacedentist/resolve.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    default_keymaps = false,
    on_conflict_detected = function(info)
      vim.keymap.set("n", "gz", "<Plug>(resolve-diff-both)", { buf = info.bufnr })
      vim.keymap.set("n", "]x", "<Plug>(resolve-next)", { buf = info.bufnr, desc = "Next conflict" })
      vim.keymap.set("n", "[x", "<Plug>(resolve-prev)", { buf = info.bufnr, desc = "Previous conflict" })
    end,
    on_conflicts_resolved = function(info)
      pcall(vim.keymap.del, "n", "gz", { buf = info.bufnr })
      pcall(vim.keymap.del, "n", "]x", { buf = info.bufnr })
      pcall(vim.keymap.del, "n", "[x", { buf = info.bufnr })
    end,
  },
}
