#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

argv=( "$@" )
argv=( "${argv[@]/\'/\'\\\'\'}" )
argv=( "${argv[@]/#/\'}" )
argv=( "${argv[@]/%/\'}" )

exec nix-shell --pure --run "exec hie-wrapper ${argv[*]}"
# nix-shell --run "hie-wrapper -d -l /tmp/hie.log"
