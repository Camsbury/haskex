{ nixpkgs ? import <nixpkgs> {} }:
let
  hiePkg = import (builtins.fetchTarball "https://github.com/domenkozar/hie-nix/tarball/master") {};
  hies = hiePkg.hies;
in
  (import ./default.nix { inherit nixpkgs; }).env.overrideAttrs (old: { buildInputs = old.buildInputs or [] ++ [ hies ]; })
