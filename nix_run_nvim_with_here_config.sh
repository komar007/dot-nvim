#!/bin/sh

# Run neovim with all provided arguments and config directory set to this directory instead of the
# default.
#
# This is done by setting XDG_CONFIG_HOME to this directory. Neovim reads the config from
# $XDG_CONFIG_HOME/nvim, so we also have a symbolic link ./nvim -> ./.
#
# Unwanted propagation of XDG_CONFIG_HOME to processes spawned by neovim (like git, for example) is
# mitigated by immediately removing this variable inside neovim's session by injecting an unlet
# command

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if nix --version >/dev/null; then
	# shellcheck disable=SC2016
	exec nix run -s XDG_CONFIG_HOME "$DIR" "$DIR" -- \
		-c "unlet \$XDG_CONFIG_HOME" \
		"$@"
else
	exec env "XDG_CONFIG_HOME=$DIR" nvim \
		-c "unlet \$XDG_CONFIG_HOME" \
		"$@"
fi
