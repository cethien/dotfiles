{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) bool str;
  cfg = config.deeznuts.boot.grub;
in
{
  options.deeznuts.boot.grub = {
    enable = mkEnableOption "Enable boot";

    efi = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable EFI support";
    };

    multiBoot = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable multi-boot";
    };

    device = mkOption {
      type = str;
      default = "/dev/sda";
      description = "The device to use for boot";
    };
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;

      efiSupport = cfg.efi;
      efiInstallAsRemovable = cfg.efi;

      useOSProber = cfg.multiBoot;

      device = cfg.device;
    };
  };
}
