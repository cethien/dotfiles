{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault optionals;
in {
  config = {
    users.users.cethien = {
      enable = mkDefault false;
      isNormalUser = true;

      extraGroups =
        ["networkmanager" "wheel"]
        ++ optionals config.virtualisation.docker.enable ["docker"]
        ++ optionals config.virtualisation.libvirtd.enable ["libvirtd" "kvm"];

      hashedPassword = "$y$j9T$OqozgiTqzcpfQ9zbKkhvr0$i4lBjUVMF1xpGCOm57m/jXVWt0KVDh/evHHFq9mF7Z4";

      openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
      ];
    };
  };
}
