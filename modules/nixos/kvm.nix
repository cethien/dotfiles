{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) str listOf passwdEntry;
  cfg = config.deeznuts.kvm;
in {
  options.deeznuts.kvm = {
    enable = mkEnableOption "VM Virtualization";
    users = mkOption {
      type = listOf (passwdEntry str);
      default = [];
      description = "List of users that can work with VMs";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    users.groups.libvirt.members = cfg.users;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;
  };
}
