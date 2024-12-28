{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.security.sops;
in
{
  options.deeznuts.security.sops = {
    enable = mkEnableOption "Enable sops";
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "~/.config/sops/age/keys.txt";
      defaultSopsFile = "../../secrets/secrets.yaml";
    };
  };
}
