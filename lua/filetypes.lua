vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["Dockerfile.dockerignore"] = "conf",
  },
  extension = {
    kbd = "kanata",
    sh = function(_, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      if string.match(first_line, '^#!.*/bin/bash') or string.match(first_line, '^#!.*/env%s+bash') then
        return 'bash'
      else
        return 'sh'
      end
    end,
  },
})
