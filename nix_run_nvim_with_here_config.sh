#!/bin/sh

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if nix --version > /dev/null; then
	env "NVIM_XDG_CONFIG_HOME=$DIR" nix run "$DIR" -- "$@"
else
	env "NVIM_XDG_CONFIG_HOME=$DIR" nvim "$@"
fi
