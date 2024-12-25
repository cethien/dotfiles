{ lib, config, ... }:

{
  options.deeznuts.users.cethien = {
    enable = lib.mkEnableOption "Enable cethien user";
  };

  config = lib.mkIf config.deeznuts.users.cethien.enable {
    users.users.cethien = {
      isNormalUser = true;
      description = "Boris";
      extraGroups = [ "networkmanager" "wheel" ];

      hashedPassword =
        "$y$j9T$OqozgiTqzcpfQ9zbKkhvr0$i4lBjUVMF1xpGCOm57m/jXVWt0KVDh/evHHFq9mF7Z4";

      openssh.authorizedKeys.keys = lib.mkIf config.deeznuts.services.ssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
      ];
    };
  };
}
