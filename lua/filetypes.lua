local utils = require('utils')

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["Dockerfile.dockerignore"] = "conf",
  },
  extension = {
    kbd = "kanata",
  },
})

vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

utils.on_ft("markdown", function()
  vim.o.textwidth = 100
  vim.o.wrap = false
  utils.setup_shell_fmt_buf("pandoc -t gfm --columns 100", function()
    -- workaround: some plugin (likely render-markdown) sets conceallevel=2 all the time...
    vim.o.conceallevel = 0
  end)
end)

utils.on_ft("sh", function()
  utils.setup_shell_fmt_buf("shfmt --case-indent")
end)

utils.on_ft("kanata", function()
  vim.opt_local.iskeyword:append("-")
  vim.opt_local.iskeyword:append("@-@")
end)

utils.on_ft("nix", function()
  vim.opt_local.iskeyword:append("-")
end)

utils.on_ft("proto", function()
  vim.opt_local.textwidth = 100
  vim.opt_local.formatoptions:append("ro")
end)

utils.on_ft("c", function()
  vim.opt_local.formatoptions:append("lron")
  vim.opt_local.textwidth = 78
end)

utils.on_ft("cpp", function()
  vim.opt_local.formatoptions:append("lron")
  vim.opt_local.textwidth = 78
  vim.opt_local.tabstop = 4
  vim.opt_local.softtabstop = -1
  vim.opt_local.shiftwidth = 4
  vim.opt_local.expandtab = true
end)

utils.on_ft("man", function()
  vim.opt_local.signcolumn = "no"
end)
