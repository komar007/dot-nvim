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
# Unwanted propagation of XDG_CONFIG_HOME to processes spawned by neovim (like git, for example) is
# mitigated by immediately removing this variable inside neovim's session by injecting an unlet
# command

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
	exec env XDG_CONFIG_HOME="$RESULT/home-files/.config/" "$RESULT/home-path/bin/nvim" \
		-c "$EXTRA_CMD" \
		"$@"
else
	exec env "XDG_CONFIG_HOME=$DIR" nvim \
		-c "$EXTRA_CMD" \
		"$@"
fi
