return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = "main",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    local timeout_ms = 5 * 60 * 1000
    local parsers = {
      "awk",
      "bash",
      "c",
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
      "jinja",
      "jinja_inline",
      "jq",
      "json",
      "kotlin",
      "nix",
      "proto",
      "python",
      "regex",
      "requirements",
      "rust",
      "scss",
      "toml",
      "xml",
      "yaml",
    }
    local treesitter = require('nvim-treesitter')
    treesitter.install(parsers):wait(timeout_ms)
    treesitter.update(parsers):wait(timeout_ms)

    local stale_parsers = vim.tbl_filter(function(p)
      return not vim.list_contains(parsers, p)
    end, treesitter.get_installed())
    treesitter.uninstall(stale_parsers):wait(timeout_ms)

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

    vim.treesitter.query.add_directive(
      "inject-template-language!",
      function(_, _, source, _, metadata)
        if type(source) ~= "number" then
          return
        end
        local name = vim.api.nvim_buf_get_name(source)
        local lang = name:match("%.([%w_]+)%.jinja$")
            or name:match("%.([%w_]+)%.jinja2$")
            or name:match("%.([%w_]+)%.j2$")
        if lang then
          metadata["injection.language"] = lang
        end
      end,
      {}
    )

    vim.filetype.add({
      extension = {
        jinja2 = "jinja",
        jinja = "jinja",
        j2 = "jinja",
      },
    })
  end,
}
