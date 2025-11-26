{ lib, nvim, ... }:
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
in
{
  config.home.packages = [ nvim ];

  config.home.file.".config/nvim" = {
    source = filteredPath ./. [
      "init.lua"
      "lazy-lock.json"
      "legacy.vim"
      "snippets/"
      "lua/"
    ];
  };
}
