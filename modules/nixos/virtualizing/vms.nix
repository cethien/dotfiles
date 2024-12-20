{ lib, config, ... }:

{
  options.virtualizing.vms = {
    enable = lib.mkEnableOption "Enable VM Virtualization";
    users = lib.mkOption {
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can work with VMs";
    };
  };

  config = lib.mkIf config.virtualizing.vms.enable {
    virtualisation.libvirtd.enable = true;
    users.groups.libvirt.members = config.virtualizing.vms.users;
    virtualisation.spiceUSBRedirection.enable = true;

    programs.virt-manager.enable = true;
  };
}
