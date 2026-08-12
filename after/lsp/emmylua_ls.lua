return {
  -- the following config is based on
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#emmylua_ls
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and
          (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
      then
        client.config.settings = {}
      end
    end
  end,
  settings = {
    emmylua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
}
