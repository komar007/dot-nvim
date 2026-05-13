return {
  'johnfrankmorgan/whitespace.nvim',
  opts = function()
    vim.cmd [[ hi ExtraWhitespace guibg=#ff7aa8 ]]
    return {
      highlight = "ExtraWhitespace",
    }
  end,
}
