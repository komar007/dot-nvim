{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          stable = import nixpkgs {
            inherit system;
          };
          unstable = import nixpkgs-unstable {
            inherit system;
          };
        in
        with stable; {
          devShells.default = mkShell {
            buildInputs = [
              # Basic dependencies (lazy + fzf native compilation)
              # ==================================================
              git
              cmake
              # telescope
              ripgrep

              # Neovim itself
              # =============
              neovim

              # Language servers
              # ================

              # clangd
              clang-tools
              # dockerls
              dockerfile-language-server-nodejs
              # docker-compose-language-service
              docker-compose-language-service
              # gopls
              go gopls
              # marksman
              (unstable.marksman.overrideAttrs (old: {
                src = fetchFromGitHub {
                  owner = "artempyanykh";
                  repo = "marksman";
                  # heading ID disambiguation fix (see: https://github.com/artempyanykh/marksman/issues/383)
                  # nixpkgs-unstable is used as base, because tooling has been upgraded between 2024-10-07 and 2024-12-18
                  rev = "2ae290a8c7352d349e1f7581fd757ce2d58268bf";
                  hash = "sha256-eN3M2RaTUivtdLcRrpUuYoWmuPtlQycv6N/P9MwoRtM=";
                };
              }))
              # jsonls
              nodePackages.vscode-json-languageserver
              # lua_ls
              lua-language-server
              # nixd
              nixd nixpkgs-fmt
              # eslint
              nodePackages.eslint
              # bashls
              nodePackages_latest.bash-language-server
              # pylsp
              python312Packages.flake8 python312Packages.python-lsp-server
              # vimls
              vim-language-server
              # yamlls
              yaml-language-server
              # protols
              protols

              # Other requirements
              # ==================

              # iamcco/markdown-preview.nvim plugin
              yarn nodejs_22 nodePackages.npm
              # for markdown formatting
              pandoc
            ];
          };
        }
      );
}
