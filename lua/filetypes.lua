local utils = require('utils')

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  extension = {
    kbd = "kanata",
  },
})

vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

utils.on_ft("markdown", function()
  vim.o.textwidth = 100
  vim.o.wrap = false
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_create_user_command(bufnr, "Fmt", function()
    local current_line = vim.fn.line('.')
    vim.cmd [[ %!pandoc -t gfm --columns 100 ]]
    vim.fn.cursor(current_line, 1)
    -- workaround: some plugin (likely render-markdown) sets conceallevel=2 all the time...
    vim.o.conceallevel = 0
  end, {})
end)

utils.on_ft("kanata", function()
  vim.opt_local.iskeyword:append("-")
  vim.opt_local.iskeyword:append("@-@")
end)

utils.on_ft("nix", function()
  vim.opt_local.iskeyword:append("-")
end)

utils.on_ft("proto", function()
  vim.opt_local.textwidth = 80
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
