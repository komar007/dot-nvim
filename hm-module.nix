{ config, nvim, ... }:
{
  config.home.packages = [ nvim ];

  config.home.file.".config/nvim" = {
    source = ./.;
    recursive = true;
  };
}
