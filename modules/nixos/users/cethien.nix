{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.users.cethien;
in {
  options.deeznuts.users.cethien = {
    enable = mkEnableOption "cethien";
  };

  config = mkIf cfg.enable {
    users.users.cethien = {
      isNormalUser = true;
      description = "boris";
      extraGroups = ["networkmanager" "wheel"];

      hashedPassword = "$y$j9T$OqozgiTqzcpfQ9zbKkhvr0$i4lBjUVMF1xpGCOm57m/jXVWt0KVDh/evHHFq9mF7Z4";

      openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
      ];
    };
  };
}
