#!/bin/sh

# Wrap a command by first undoing effects of direnv in the current environment and then running the
# command in the environment

set -e

DIRENV_UNLOAD=""
if direnv --version > /dev/null; then
	T=$(mktemp -d) # guaranteed to have no .envrc
	cd "$T" > /dev/null || exit
	DIRENV_UNLOAD="$(direnv export bash)"
	cd - > /dev/null || exit
	rmdir "$T"
fi
eval "$DIRENV_UNLOAD"

exec "$@"
