{ lib, config, ... }:

{
  options.deeznuts.boot.grub = {
    enable = lib.mkEnableOption "Enable boot";

    efi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable EFI support";
    };

    multiBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable multi-boot";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/sda";
      description = "The device to use for boot";
    };
  };

  config = lib.mkIf config.deeznuts.boot.grub.enable {
    boot.loader.grub = {
      enable = true;

      efiSupport = config.deeznuts.boot.grub.efi;
      efiInstallAsRemovable = config.deeznuts.boot.grub.efi;

      useOSProber = config.deeznuts.boot.grub.multiBoot;

      device = config.deeznuts.boot.grub.device;
    };
  };
}
