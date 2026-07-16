{ stable, unstable, ... }:
with stable;
[
  # Basic dependencies (lazy + treesitter modules compilation)
  # ==========================================================

  cmake
  curl
  gcc
  git
  gnumake
  gnutar
  gzip
  luaPackages.tree-sitter-cli

  # Other dependencies / tools
  # ==========================

  delta
  direnv
  ripgrep
  pandoc # for markdown formatting
  shfmt # for shell formatting

  # iamcco/markdown-preview.nvim plugin
  yarn
  nodejs_22
  unstable.surf # not for the plugin itself, but to open preview in surf specifically

  # Language servers
  # ================

  # bashls
  unstable.bash-language-server
  # clangd
  clang-tools
  # cssls
  vscode-css-languageserver
  # docker-compose-language-service
  docker-compose-language-service
  # dockerls
  dockerfile-language-server
  # eslint
  eslint
  # fsautocomplete
  fsautocomplete
  # gopls
  go
  gopls
  # hls
  ghc
  haskell-language-server
  # jqls
  unstable.jq-lsp
  # jsonls
  vscode-json-languageserver
  # lua_ls
  lua-language-server
  # marksman
  unstable.marksman
  # nixd
  nixd
  nixfmt
  # postgres_lsp
  postgres-language-server
  # protols
  unstable.protols
  # pyright
  pyright
  # ruff
  ruff
  # taplo
  taplo
  # ts_ls
  typescript-language-server
  # vacuum
  vacuum-go
  # vimls
  vim-language-server
  # yamlls
  yaml-language-server
]
