# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

let
  sources = import ./nix/sources.nix;

  moz_overlay = import (sources.nixpkgs-mozilla);
  pkgs_with_rust = moz_overlay pkgs_with_rust pkgs;

  # From https://github.com/edolstra/import-cargo
  import-cargo-flake = (import "${sources.import-cargo}/flake.nix").outputs { self = import-cargo-flake; };
  importCargo = lockFile: import-cargo-flake.builders.importCargo { inherit pkgs lockFile; };

in rec {
  lib = {
    inherit importCargo;
  };

  setuptools-rust = pkgs.python3Packages.callPackage ./pkgs/setuptools-rust.nix {};
  tokenizers = pkgs.python3Packages.callPackage ./pkgs/tokenizers.nix {
    rustChannelOf = pkgs_with_rust.rustChannelOf;
    inherit importCargo setuptools-rust;
  };
  transformers = pkgs.python3Packages.callPackage ./pkgs/transformers.nix { inherit tokenizers; };
  sentence-transformers = pkgs.python3Packages.callPackage ./pkgs/sentence-transformers.nix { inherit transformers; };
}
