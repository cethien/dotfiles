{ lib, config, pkgs, ... }:

{
  options.user.apps.whatsapp = {
    enable = lib.mkEnableOption "WhatsApp";
  };

  config = lib.mkIf config.user.apps.whatsapp.enable {
    programs.command-not-found = {
      enable = true;
    };

    home.packages = [ 
      (pkgs.writeShellScriptBin "whatsapp-for-linux" ''
        #!/usr/bin/env bash
        WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.whatsapp-for-linux}/bin/whatsapp-for-linux "$@"
      '')];
  };
}