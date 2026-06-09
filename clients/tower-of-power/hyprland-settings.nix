{
  hLib,
  lib,
  monitors,
  ...
}: {
  settings = let
    l = lib.generators.mkLuaInline;
  in {
    asus._var = monitors.asus;
    arzopa._var = monitors.arzopa;

    config.general.allow_tearing = true;
    monitor = [
      {
        _args = [
          {
            output = l "asus";
            mode = "2560x1440@240";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = 2;
          }
        ];
      }
      {
        _args = [
          {
            output = l "arzopa";
            mode = "1920x1080@100";
            position = "320x1440";
            scale = 1;
          }
        ];
      }
    ];

    workspace_rule = [
      # --- Arzopa Workspaces ---
      {
        _args = [
          {
            workspace = "4";
            monitor = l "arzopa";
            persistent = true;
            default = true;
            layout = "master";
          }
        ];
      }
      {
        _args = [
          {
            workspace = "5";
            monitor = l "arzopa";
            persistent = true;
          }
        ];
      }

      # --- Asus Workspaces ---
      {
        _args = [
          {
            workspace = "1";
            monitor = l "asus";
            persistent = true;
            default = true;
            layout = "master";
          }
        ];
      }
      {
        _args = [
          {
            workspace = "2";
            monitor = l "asus";
            persistent = true;
          }
        ];
      }
      {
        _args = [
          {
            workspace = "3";
            monitor = l "asus";
            persistent = true;
          }
        ];
      }
      {
        _args = [
          {
            workspace = "9";
            monitor = l "asus";
          }
        ];
      }
      {
        _args = [
          {
            workspace = "10";
            monitor = l "asus";
          }
        ];
      }
    ];

    on = [(hLib.mkAutostart "xrandr --output DP-1 --primary" {})];
  };

  defaultWorkspaces = {
    console_launcher = 9;
    gaming = 10;
    browser = 4;
    pip = 4;
  };
}
