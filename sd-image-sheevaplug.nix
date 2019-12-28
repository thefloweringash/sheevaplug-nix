{ config, lib, pkgs, modulesPath, ... }:

let
  extlinux-conf-builder =
    import "${modulesPath}/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix" {
      pkgs = pkgs.buildPackages;
    };
in
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/installation-device.nix"
    "${modulesPath}/installer/cd-dvd/sd-image.nix"
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "console=ttyS0,115200n8" ];
  boot.initrd.availableKernelModules = [ "usb_storage" "ehci-orion" "orion_nand" "mvsdio" ];

  sdImage = {
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;

  nixpkgs.crossSystem = import ./platform.nix { inherit lib; };

  # minimal settings
  programs.command-not-found.enable = false;
  security.polkit.enable = false;
  services.udisks2.enable = false;
  documentation.enable = false;
  environment.noXlibs = true;
  hardware.enableRedistributableFirmware = false;

  boot.supportedFilesystems = lib.mkForce [ "ext4" ];
  networking.wireless.enable = false;
}
