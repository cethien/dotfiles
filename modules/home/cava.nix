{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.cava.settings = {
      general = {
        framerate = 120;
        sensitivity = 33;
      };
      smoothing = {
        noise_reduction = 66;
        monstercat = 1;
        # waves = 1;
      };
      output = {
        reverse = 1;
      };
      color = {
        # background = "#000000";
        foreground = "#61afef";
      };
    };
  };
}
