{
  config,
  lib,
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
in
{
  options.dot-nvim.quirks.gitBranchSymbol = lib.mkOption {
    type = lib.types.str;
    description = "the symbol used to represent a git branch";
    default = "⎇";
  };

  config.home.packages = [ nvim ];

  config.home.file.".config/nvim" = {
    source = filteredPath ./. [
      "init.lua"
      "lazy-lock.json"
      "legacy.vim"
      "snippets/"
      "lua/"
    ];
    recursive = true;
  };

  config.home.file.".config/nvim/lua/quirks.lua".text = ''
    return {
      git_branch_symbol = '${branchSymbol}',
    }
  '';

  config.home.sessionVariables = {
    DOT_NVIM_GIT_BRANCH_SYMBOL = branchSymbol;
  };
}
