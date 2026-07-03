#!/bin/sh

# Run neovim with all provided arguments and config directory set to this directory instead of the
# default.
#
# In non-nix mode this is done by setting XDG_CONFIG_HOME to this directory. Neovim reads the config
# from $XDG_CONFIG_HOME/nvim, so we also have a symbolic link ./nvim -> ./. Also XDG_DATA_HOME is
# set to an alternative directory so that the plugins installed by lazy.nvim are separated from the
# plugins potentially installed in ~/.config/nvim.
#
# In nix mode, a dummy home-manager configuration is built (containing just wrapped neovim and
# config) and XDG_CONFIG_HOME is set to the dummy home directory built using home-manager.
# XDG_DATA_HOME is set to the respective directory inside the dummy home too.
#
# Running with XDG_CONFIG_HOME set to the built configuration has the advantage of vim being run on
# read-only configuration files so it cannot modify anything, especially lazy-lock.json.
# This is also a disadvantage for the very same reason - it is not possible to use :Lazy inside
# neovim started by this script to update lazy-lock.json.
#
# Allowing lazy.nvim to update lazy-lock.json can be achieved by overriding lazy.nvim's lockfile
# path which is done using LAZY_NVIM_LOCKFILE environment variable, checked by init.lua.
#
# Unwanted propagation of XDG_*_HOME to processes spawned by neovim (like git, for example) is
# mitigated by immediately removing these variables inside neovim's session by injecting an unlet
# command. While the neovim configuration is read from XDG_CONFIG_HOME and lazy loads the plugins
# from XDG_DATA_HOME, vim.fn.stdpath(...) returns the "original", "post-unlet" paths later. This
# should be mostly harmless and may even have an advantage, since some plugins store data in
# XDG_DATA_HOME (for example input history of telescope and snacks), and such data is expected to be
# shared between the configurations of neovim.

set -e

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

EXTRA_CMD="unlet \$XDG_CONFIG_HOME \$XDG_DATA_HOME \$XDG_CACHE_HOME | let g:is_alternative_config=v:true"

BASE=${HERE_CONFIG_BASE:-$DIR/.here_config}
RESULT=${BASE}/result
OUTPUT=${BASE}/output
if nix --version >/dev/null; then
	SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')
	BUILT_HERE_CONFIG_ROOT="$OUTPUT" nix build \
		--out-link "$RESULT" \
		--impure \
		"${DIR}#homeConfigurations.${SYSTEM}.hereConfig.activationPackage"
	mkdir -p "$OUTPUT" && HOME="$OUTPUT" "$RESULT"/activate
	exec env \
		XDG_CONFIG_HOME="$OUTPUT/.config/" \
		XDG_DATA_HOME="$OUTPUT/.local/share" \
		XDG_CACHE_HOME="$OUTPUT/.cache" \
		"$RESULT/home-path/bin/nvim" -c "$EXTRA_CMD" "$@"
else
	exec env \
		XDG_CONFIG_HOME="$DIR" \
		XDG_DATA_HOME="$OUTPUT/.local/share" \
		XDG_CACHE_HOME="$OUTPUT/.cache/" \
		nvim -c "$EXTRA_CMD" "$@"
fi
