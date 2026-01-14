#!/bin/sh

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if nix --version > /dev/null; then
	exec nix run -s XDG_CONFIG_HOME "$DIR" "$DIR" -- "$@"
else
	exec env "XDG_CONFIG_HOME=$DIR" nvim "$@"
fi
