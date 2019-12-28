{ nixpkgs ? import ./pinned-nixpkgs.nix {} }:

nixpkgs.pkgsCross.sheevaplug.ubootSheevaplug.overrideAttrs (x: {
  patches = (x.patches or []) ++ [ ./uboot-distro.patch ];
})
