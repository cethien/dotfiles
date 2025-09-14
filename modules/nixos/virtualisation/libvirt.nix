{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.virtualisation.libvirt;
in {
  options.deeznuts.virtualisation.libvirt = {
    enable = mkEnableOption "VMs via libvirt";
    users = mkOption {
      type = types.listOf (types.passwdEntry types.str);
      default = [];
      description = "List of users that can work with VMs";
    };
    virt-manager.enable = mkOption {
      type = types.bool;
      default = true;
      description = "virt-manager";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
      multipass.enable = true;
    };
    users.groups.libvirt.members = cfg.users;
    programs.virt-manager.enable = cfg.virt-manager.enable;
  };
}
