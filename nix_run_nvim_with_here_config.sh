#!/bin/sh

# Run neovim with all provided arguments and config directory set to this directory instead of the
# default.
#
# In non-nix mode this is done by setting XDG_CONFIG_HOME to this directory. Neovim reads the config
# from $XDG_CONFIG_HOME/nvim, so we also have a symbolic link ./nvim -> ./.
#
# In nix mode, a dummy home-manager configuration is built (containing just wrapped neovim and
# config) and XDG_CONFIG_HOME is set to the built configuration.
#
# Running with XDG_CONFIG_HOME set to the built configuration has the advantage of vim being run on
# mostly(*) read-only configuration files so it cannot modify anything, especially lazy-lock.json.
# This is also a disadvantage for the very same reason - it is not possible to use :Lazy inside
# neovim started by this script to update lazy-lock.nvim (plugins themselves are managed in
# ~/.local/share/nvim which we do not override here).
#
# That's why this script accepts NIX_RUN_NVIM_WITH_HERE_CONFIG_GENERATED=false in which case,
# instead of setting XDG_CONFIG_HOME to the generated config, it sets it to this repository. This
# can be used to perform lazy-nvim tasks in a non-sandboxed environment.
#
# Unwanted propagation of XDG_CONFIG_HOME to processes spawned by neovim (like git, for example) is
# mitigated by immediately removing this variable inside neovim's session by injecting an unlet
# command
#
# (*) - currently we are using recursive = true for config.home.file.".config/nvim", but it is just
# because it was easier to add generation of quirks.lua this way. This should probably be changed
# one day.

set -e

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

EXTRA_CMD="unlet \$XDG_CONFIG_HOME | let g:is_alternative_config=v:true"

RESULT=$DIR/.tmp_hm_result # TODO: consider ~/.cache or something
if nix --version >/dev/null; then
	SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')
	nix build \
		--out-link "$RESULT" \
		--impure \
		"${DIR}#homeConfigurations.${SYSTEM}.default.activationPackage"
	if [ "${NIX_RUN_NVIM_WITH_HERE_CONFIG_GENERATED}" = false ]; then
		CONFIG_DIR="$DIR"
	else
		CONFIG_DIR="$RESULT/home-files/.config/"
	fi
	exec env XDG_CONFIG_HOME="$CONFIG_DIR" "$RESULT/home-path/bin/nvim" \
		-c "$EXTRA_CMD" \
		"$@"
else
	exec env "XDG_CONFIG_HOME=$DIR" nvim \
		-c "$EXTRA_CMD" \
		"$@"
fi
