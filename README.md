# Neovim config

This is my everyday neovim config, used mainly for work.

Everything is provided in hope that it will be useful, but all in all it is just what I find useful
and it’s nothing but my private preferences grouped together and made public. Enjoy!

![Neovim config
screenshot](/../main/screenshot1.png?raw=true "Neovim config screenshot: LSP documentation")

## Howto

What to do if you want to try out this configuration?

### If you are using Nix (on NixOS or not)

This repository is a flake which provides a package, a devshell and a home-manager module.

The simplest way to use this configuration is to use the provided home-manager module.

Backup and remove your current `~/.config/nvim` (unless you already manage it using home-manager -
then disable your own configuration), then add the flake input like so:

``` nix
{
  description = "...";
  inputs = {
    #...
    komar-nvim.url = "github:komar007/neovim-config";
    #...
  };
  #...
}
```

Then, add the module provided in `homeManagerModules` output of the flake to your home-manager
configuration:

``` nix
{
  description = "...";
  inputs = { #... }
  outputs = { self, nixpkgs, home-manager, komar-nvim, ... } @ inputs:
  homeConfigurations =
  let
    system = "x86_64-linux";
    komar-nvim-module = system: komar-nvim.homeManagerModules.${system}.default;
  in
  {
    home = home-manager.lib.homeManagerConfiguration {
      #...
      modules = [
          komar-nvim-module
      ];
      #...
    }
  };
}
```

Remember to remove neovim from the list of packages to avoid conflict and run `home-manager switch`.

#### Making changes

Making changes to the configuration and package requires that you clone the repository and switch
neovim to use both the package and configuration from the repository instead of `~/.config/nvim`
(which is managed by nix and flake-locked to the github repository). Fortunately, you can do this
quite easily with the provided `nvim_cold_reload` wrapper.

First, clone the repository somewhere:

``` sh
git clone --recurse-submodules https://github.com/komar007/neovim-config.git ~/repos/neovim-config
```

Then, for convenience, set an alias to the wrapper:

``` sh
alias nvim=~/repos/neovim-config/nvim_wrapper
```

Then, run `nvim` and inside of neovim, `:ReloadAlt` (provided by wrapper). This reloads neovim to an
alternative configuration which uses the package (neovim + dependencies like LSP servers) and the
configuration from the flake (cloned to `~/repos/neovim-config`). You can then use `:Reload` as you
work on the configuration. `:ReloadNorm` takes you back to the flake-locked configuration and
package.

When you finally fork this repository on github, you can maintain a stable version of your
configuration in the fork. After you introduce a change, switch to it and test “in production” in
one of you open sessions with `:ReloadAlt` and go back with `:ReloadNorm`. When the change is
stable, push to gerrit, update your home-manager’s flake input `komar-nvim` and run
`home-manager switch`.

### If you are not using Nix (and don’t want to (…but you should, really))

I manage the installed LSP servers using Nix and you will either need it or have to provide all the
required executables via `PATH`.

To try the configuration without the LSP servers, you can override `XDG_CONFIG_HOME` to point to
this repository, for example:

``` sh
git clone https://github.com/komar007/neovim-config.git ~/repos/neovim-config
XDG_CONFIG_HOME=~/repos/neovim-config nvim
```

Or you can wipe your own configuration and clone mine directly into neovim’s config directory, like
so:

``` sh
rm -fr ~/.config/nvim
git clone https://github.com/komar007/neovim-config.git ~/.config/nvim
nvim
```

You may want to backup your `~/.local/share/nvim` and `~/.local/state/nvim` directories before doing
that though.

This repo uses
[komar007/nvim_cold_reload.sh](https://gist.github.com/komar007/00f775b30f70ef51fca66cc883ca265e),
you can give it a try by setting an alias that resolves to `nvim_wrapper`, for example like so:

``` sh
alias nvim=~/repos/neovim-config/nvim_wrapper
```

(but remember to use `--recurse-submodules` when cloning)

Now you can use `:Reload` to quickly reload neovim with new configuration keeping your current
session intact.

If you are not on Nix, `:ReloadAlt` will run the same `nvim` executable, but will actually load the
configuration from the directory in which the wrapper resides. This will make absolutely no sense if
you have this repository cloned into `~/.config/nvim` or linked there, but if you just want to try
it, instead of setting `XDG_CONFIG_HOME` yourself, you can use `nvim_wrapper`. It will run neovim
normally, with whatever you have in `~/.config/nvim`, but then switch the configuration when you run
`:ReloadAlt`. And you’ll also get cold reload as a bonus.

You may also do everything above if you do use Nix, BTW.

## Screenshots

Snacks picker live grep ![Neovim config
screenshot](/../main/screenshot2.png?raw=true "Neovim config screenshot: snacks picker live grep")

Diffview plugin + diff colors ![Neovim config
screenshot](/../main/screenshot3.png?raw=true "Neovim config screenshot: Diffview plugin + diff colors")

Code actions preview ![Neovim config
screenshot](/../main/screenshot4.png?raw=true "Neovim config screenshot: code actions preview")
