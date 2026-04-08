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
  -- workaround: assume markdown + float = signature help/hover and set better looking options
  local is_lsp_float = pcall(vim.api.nvim_win_get_var, 0, "lsp_floating_bufnr")
  if is_lsp_float then
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    return
  end

  vim.opt_local.wrap = false
  vim.opt_local.textwidth = 100

  utils.setup_shell_fmt_buf("pandoc -t gfm --columns 100")
end)

utils.on_ft("sh", function()
  utils.setup_shell_fmt_buf("shfmt --filename %")
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

utils.on_ft("man", function(ev)
  vim.opt_local.signcolumn = "no"
  vim.opt_local.scrolloff = 1000
  vim.opt_local.wrapscan = false
  vim.b[ev.buf].snacks_scroll = false
  vim.keymap.set("n", "<space>", "<C-f>", { buffer = ev.buf, noremap = true, silent = true })
end)

utils.on_ft("oil", function()
  vim.o.textwidth = 0
end)
