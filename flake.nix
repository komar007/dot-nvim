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
        getExe = stable.lib.getExe;
      in
      rec {
        devShells.default = stable.mkShell {
          buildInputs = dependencies ++ [ neovim ];
        };
        packages = rec {
          # neovim with all dependencies required by config
          nvim_with_deps = stable.writeShellApplication {
            name = "nvim";
            runtimeInputs = dependencies;
            text = ''${neovim}/bin/nvim "$@"'';
          };
          # a tool which unloads any .envrc previously loaded via direnv before spawning the wrapped
          # program
          with_unloaded_direnv = stable.writeShellApplication {
            name = "nvim";
            runtimeInputs = [ stable.coreutils ];
            text = builtins.readFile ./with_unloaded_direnv.sh;
          };
          # Unload any previously loaded direnv, as neovim manages direnv itself
          #
          # The "hack" below is specific to the design of this neovim configuration where neovim is
          # a nix package that contains its executable dependencies (LSPs, rg, etc.) as
          # `runtimeInputs` which essentially makes it a wrapper that extends PATH before spawning
          # original nvim. This causes problems if the nix package is started in a direnv-enabled
          # environment, as the environment likely overrides PATH (especially with `use flake`).
          #
          # Not doing the unloading would cause direnv reloading inside NotAShelf/direnv.nvim to
          # break runtimeInputs in direnv directories with `use flake` (or any PATH
          # appending/prepending):
          # - .envrc in current directory appends to PATH,
          # - neovim wrapped in a subshell appending deps to PATH spawned (*),
          # - :Direnv reload restores environment state serialized by direnv before entering current
          #   directory causing changes to PATH introduced in (*) to be lost,
          # - direnv applies new (or updated) .envrc,
          # - result: neovim does not recognize dependencies: LSPs, basic tools, etc.
          #
          # Unloading the changes currently applied by direnv before spawning nvim wrapped with its
          # dependencies (whether it's a package or devshell) makes sure that the dependencies
          # provided by this flake are the starting point for any direnv reloads happening inside
          # neovim and will not be lost. `autoload_direnv` makes sure that the current directory's
          # .envrc will be immediately loaded anyway.
          nvim_with_deps_unloaded_direnv = stable.writeShellApplication {
            name = "nvim";
            text = ''${getExe with_unloaded_direnv} ${getExe nvim_with_deps} "$@"'';
          };
          default = nvim_with_deps_unloaded_direnv;
        };
        homeManagerModules.default =
          args: import ./hm-module.nix (args // { nvim = packages.nvim_with_deps_unloaded_direnv; });

        formatter = treefmtEval.config.build.wrapper;
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
