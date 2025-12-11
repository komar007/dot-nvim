{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    systems.url = "github:nix-systems/default-linux";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        stable = import inputs.nixpkgs {
          inherit system;
        };
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
        };
        neovim = stable.neovim;
        # provide the include path containing the well-known protos from protobuf,
        # hijacking protols's pkg-config-based detection
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
          dockerfile-language-server
          # docker-compose-language-service
          docker-compose-language-service
          # fsautocomplete
          fsautocomplete
          # gopls
          go
          gopls
          # marksman
          unstable.marksman
          # jsonls
          nodePackages.vscode-json-languageserver
          # jqls
          unstable.jq-lsp
          # taplo
          taplo
          # lua_ls
          lua-language-server
          # nixd
          nixd
          nixfmt-rfc-style
          # eslint
          nodePackages.eslint
          # bashls
          unstable.bash-language-server
          # pyright
          pyright
          # vacuum
          vacuum-go
          # vimls
          vim-language-server
          # yamlls
          yaml-language-server
          # protols
          unstable.protols
          # ruff
          ruff
          # ts_ls
          typescript-language-server

          # Other requirements
          # ==================

          # iamcco/markdown-preview.nvim plugin
          yarn
          nodejs_22
          nodePackages.npm
          # for markdown formatting
          pandoc
          # for shell formatting
          shfmt
        ];
        treefmtEval = inputs.treefmt-nix.lib.evalModule stable ./treefmt.nix;
      in
      rec {
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

        formatter = treefmtEval.config.build.wrapper;
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
