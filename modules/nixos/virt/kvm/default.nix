{ lib, config, ... }:

{
  options.deeznuts.virt.kvm = {
    enable = lib.mkEnableOption "Enable VM Virtualization";
    users = lib.mkOption {
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can work with VMs";
    };
  };

  config = lib.mkIf config.deeznuts.virt.kvm.enable {
    virtualisation.libvirtd.enable = true;
    users.groups.libvirt.members = config.deeznuts.virt.kvm.users;
    virtualisation.spiceUSBRedirection.enable = true;

    programs.virt-manager.enable = true;
  };
}
