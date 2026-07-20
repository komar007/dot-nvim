return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = "main",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter').install({
      "css",
      "diff",
      "dockerfile",
      "fsharp",
      "gitcommit",
      "gitignore",
      "git_rebase",
      "go",
      "gomod",
      "gosum",
      "haskell",
      "html",
      "java",
      "javascript",
      "jq",
      "json",
      "kotlin",
      "nix",
      "python",
      "regex",
      "rust",
      "toml",
      "xml",
      "yaml",
    }):wait(300000)

    local group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        local parser_available = vim.treesitter.language.add(lang)
        if not parser_available then
          return
        end
        vim.treesitter.start(args.buf, lang)
      end,
    })
  end,
}
