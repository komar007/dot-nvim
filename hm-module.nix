{
  config,
  lib,
  pkgs,
  nvim,
  ...
}:
let
  relPath = base: lib.strings.removePrefix (toString base + "/");
  filteredPath =
    base: patterns:
    builtins.path {
      path = base;
      filter =
        nixPath: type:
        let
          path = relPath base nixPath + (if type == "directory" then "/" else "");
        in
        builtins.foldl' (a: b: a || b) false (
          builtins.map (
            pat: if lib.strings.hasSuffix "/" pat then lib.strings.hasPrefix pat path else path == pat
          ) patterns
        );
    };
  branchSymbol = config.dot-nvim.quirks.gitBranchSymbol;
  appname = config.dot-nvim.appname;
in
{
  options.dot-nvim = {
    appname = lib.mkOption {
      type = lib.types.str;
      description = "the name of the config directory in ~/.config/ to populate";
      default = "nvim";
    };
    quirks.gitBranchSymbol = lib.mkOption {
      type = lib.types.str;
      description = "the symbol used to represent a git branch";
      default = "⎇";
    };
    lazy.locked = lib.mkOption {
      type = lib.types.bool;
      description = "verify that lazy-lock.json is in sync with plugin config during activation";
      default = true;
    };
  };

  config.home.packages = [ nvim ];

  config.home.file.".config/${appname}" = {
    source = pkgs.symlinkJoin {
      name = "dot-nvim-generated-config";
      paths = [
        (filteredPath ./. [
          "init.lua"
          "lazy-lock.json"
          "legacy.vim"
          "snippets/"
          "lua/"
        ])
        (pkgs.writeTextFile {
          name = "quirks.lua";
          destination = "/lua/quirks.lua";
          text = ''
            return {
              git_branch_symbol = '${branchSymbol}',
            }
          '';
        })
      ];
    };
  };

  # TODO: implement VERBOSE and DRY_RUN required by home.activation
  config.home.activation.updateNvimDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -e

    CURRENT_CONFIG="$(readlink "$HOME"/.config/nvim)"
    DATA_CONFIG_LINK="$HOME"/.local/share/nvim/config
    if [ -L "$DATA_CONFIG_LINK" ] && [ "$(readlink "$DATA_CONFIG_LINK")" = "$CURRENT_CONFIG" ]; then
      exit 0
    fi

    T=$(mktemp -d)
    cleanup() {
      rm -fr "$T"
    }
    trap cleanup EXIT
    cat "$HOME/.config/nvim/lazy-lock.json" > "$T/lazy-lock.json"
    env \
        XDG_CONFIG_HOME="$HOME/.config" \
        XDG_DATA_HOME="$HOME/.local/share" \
        LAZY_NVIM_LOCKFILE="$T/lazy-lock.json" \
        ${lib.getExe nvim} --headless "+LazyHeadless restore" 2>&1 |
      while IFS= read -r line; do
        printf "\r\033[KRestoring lazy.nvim: %s" "$line"
      done
    printf "\r\033[KRestored lazy.nvim\n"
    ${
      if config.dot-nvim.lazy.locked then
        ''
          diff -Naur "$HOME/.config/nvim/lazy-lock.json" "$T/lazy-lock.json" > "$T/lock-diff" ||
            (echo "ERROR: lazy-lock.json would be updated, aborting" && cat "$T/lock-diff" && exit 1)
        ''
      else
        ""
    }
    ln -sfn "$CURRENT_CONFIG" "$DATA_CONFIG_LINK"
  '';

  config.home.sessionVariables = {
    DOT_NVIM_GIT_BRANCH_SYMBOL = branchSymbol;
  };
}
