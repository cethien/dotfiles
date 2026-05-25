{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.mako.enable {
    stylix.targets.mako.opacity.enable = false;

    services.mako = {
      settings = {
        actions = true;
        anchor = "top-center";
        border-radius = 4;
        default-timeout = 3000;
        ignore-timeout = false;
        height = 400;
        icons = true;
        layer = "top";
        margin = "16,8,8";
        padding = 16;
        markup = true;
        width = 600;
      };
    };
  };
}
