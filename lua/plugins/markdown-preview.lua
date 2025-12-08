return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    function Open_url(url)
      local cmd = { "surf", url }
      vim.fn.jobstart(cmd, { detach = true })
    end
    vim.cmd [[
      function! OpenUrl(url) abort
        return v:lua.Open_url(a:url)
      endfunction
    ]]
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_theme = "dark"
    vim.g.mkdp_browserfunc = "OpenUrl"
  end,
  ft = { "markdown" },
}
