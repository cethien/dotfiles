{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  config = {
    programs.mangohud = {
      package = pkgs-unstable.mangohud;
      settings = {
        position = "top-left";
        horizontal = true;
        horizontal_stretch = 0;
        hud_compact = true;
        hud_no_margin = true;
        background_alpha = lib.mkForce 0.3;

        gpu_stats = true;
        cpu_stats = true;
        histogram = true;
        frametime = false;
      };
    };
  };
}
