{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.virtualisation.libvirtd;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
        };
      };
    };
    programs.virt-manager.enable = config.deeznuts.desktop.isEnabled;
  };
}
