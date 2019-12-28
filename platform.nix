{ lib }:
let
  base = lib.systems.examples.sheevaplug;
in base // {
  system = "armv5tel-linux";
  platform = base.platform // {
    kernelAutoModules = true;
    kernelExtraConfig = ''
      # Disable OABI to have seccomp_filter (required for systemd)
      # https://github.com/raspberrypi/firmware/issues/651
      OABI_COMPAT n

      # Onboard serial
      SERIAL_OF_PLATFORM y
    '';
  };
}
