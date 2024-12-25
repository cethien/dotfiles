{ config, lib, ... }:

{
  options.deeznuts.security.sops.enable = lib.mkEnableOption "Enable sops";

  config = lib.mkIf config.deeznuts.security.sops.enable {
    sops = {
      age.keyFile = "~/.config/sops/age/keys.txt";

      defaultSopsFile = "../../secrets/secrets.yaml";
    };

  };
}
