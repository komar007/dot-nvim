#!/bin/sh

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

T=$(mktemp -d)
cleanup() {
	rm -fr "$T"
}
trap cleanup EXIT

export HERE_CONFIG_BASE="$D"
export LAZY_NVIM_LOCKFILE="$DIR"/lazy-lock.json
export LAZY_NVIM_UNLOCKED=true
"$DIR"/nix_run_nvim_with_here_config.sh --headless "+LazyHeadless $*"
