#!/bin/sh

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

export LAZY_NVIM_LOCKFILE="$DIR"/lazy-lock.json
"$DIR"/nix_run_nvim_with_here_config.sh --headless "+LazyHeadless $*"
