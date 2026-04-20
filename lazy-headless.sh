#!/bin/sh

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

export NIX_RUN_NVIM_WITH_HERE_CONFIG_GENERATED=false
"$DIR"/nix_run_nvim_with_here_config.sh --headless "+Lazy! $*" +qa
