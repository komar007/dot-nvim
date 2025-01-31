return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
    })
    -- workaround, because diffview sets this on setup based on DiffDelete instead of linking
    vim.cmd [[ hi DiffviewDiffAddAsDelete guibg=#200606 guifg=NONE guisp=#444444 gui=NONE ]]

    -- Diffview hack???
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "diff",
      callback = function()
        vim.opt_local.wrap = false
      end,
    })
  end
}
