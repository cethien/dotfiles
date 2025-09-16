{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.virtualisation.libvirt;
in {
  options.deeznuts.virtualisation.libvirt = {
    enable = mkEnableOption "VMs via libvirt";
    users = mkOption {
      type = types.listOf (types.passwdEntry types.str);
      default = [];
      description = "List of users that can work with VMs";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
      multipass.enable = true;
    };
    users.groups.libvirt.members = cfg.users;
    programs.virt-manager.enable = config.deeznuts.desktop.isEnabled;
  };
}
