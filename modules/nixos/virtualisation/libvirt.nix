{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.virtualisation.libvirtd;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      spiceUSBRedirection.enable = true;
      multipass.enable = true;
    };
    programs.virt-manager.enable = config.deeznuts.desktop.isEnabled;
  };
}
