{ lib, config, pkgs, ... }:

{
  options.user.apps.whatsapp = {
    enable = lib.mkEnableOption "WhatsApp";
  };

  config = lib.mkIf config.user.apps.whatsapp.enable {
    home.sessionVariables = {
      WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    };

    home.packages = [ pkgs.whatsapp-for-linux ];
  };
}