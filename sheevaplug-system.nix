{ pkgs ? import ./pinned-nixpkgs.nix {} }:

import (pkgs.path + "/nixos") {
  configuration = ./sd-image-sheevaplug.nix;
}
