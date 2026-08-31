{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-mail;
  inherit (config.lib.deeznuts) mkArgcBashBin;

  smail = mkArgcBashBin {
    src = ./smail.sh;
    extraRuntimeDeps = with pkgs; [
      msmtp
    ];
  };
in {
  options.programs.utils-mail.enable = lib.mkEnableOption "network utilities";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      smail
    ];
  };
}
