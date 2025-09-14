{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (elem "cethien" config.deeznuts.users) {
    users.users.cethien = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      hashedPassword = "$y$j9T$OqozgiTqzcpfQ9zbKkhvr0$i4lBjUVMF1xpGCOm57m/jXVWt0KVDh/evHHFq9mF7Z4";
      openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
      ];
    };
  };
}
