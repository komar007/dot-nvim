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
          neovim = stable.neovim;
          dependencies = with stable; [
            # Basic dependencies (lazy + fzf native compilation)
            # ==================================================
            git
            cmake
            # telescope
            ripgrep

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
            # taplo
            taplo
            # lua_ls
            lua-language-server
            # nixd
            nixd nixpkgs-fmt
            # eslint
            nodePackages.eslint
            # bashls
            nodePackages_latest.bash-language-server
            # pyright
            pyright
            # vacuum
            vacuum-go
            # vimls
            vim-language-server
            # yamlls
            yaml-language-server
            # protols
            protols
            # ruff
            ruff

            # Other requirements
            # ==================

            # iamcco/markdown-preview.nvim plugin
            yarn nodejs_22 nodePackages.npm
            # for markdown formatting
            pandoc
            # for shell formatting
            shfmt
          ];
        in rec {
          devShells.default = stable.mkShell {
            buildInputs = dependencies ++ [ neovim ];
          };
          packages.nvim = stable.writeShellApplication {
            name = "nvim";
            runtimeInputs = dependencies;
            text = ''
              if [[ -v NVIM_XDG_CONFIG_HOME ]]; then
                export XDG_CONFIG_HOME="''${NVIM_XDG_CONFIG_HOME}"
              fi
              ${neovim}/bin/nvim "$@"
            '';
          };
          packages.default = packages.nvim;
          homeManagerModules.default = args: import ./hm-module.nix (args // { nvim = packages.nvim; });
        }
      );
}
