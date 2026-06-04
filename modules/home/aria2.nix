{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    programs.aria2 = {
      systemd.enable = true;
      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
        enable-rpc = true;
        seed-time = 0;
      };
    };
  };
}
