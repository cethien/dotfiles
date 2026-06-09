{
  hLib,
  lib,
  monitors,
  ...
}: {
  settings = let
    l = lib.generators.mkLuaInline;
  in {
    monitor_self._var = monitors.self;
    asus._var = monitors.asus;
    arzopa._var = monitors.arzopa;
    eizo._var = monitors.eizo;

    config.general.allow_tearing = true;
    monitor = [
      {
        _args = [
          {
            output = l "asus";
            mode = "2560x1440@60";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
          }
        ];
      }
      {
        _args = [
          {
            output = l "eizo";
            mode = "1920x1200@60";
            position = "0x0";
            scale = 1;
          }
        ];
      }

      {
        _args = [
          {
            output = l "monitor_self";
            mode = "1920x1080@60";
            position = "320x1440";
            scale = 1;
          }
        ];
      }
    ];

    workspace_rule = [
      {
        _args = [
          {
            workspace = 10;
            monitor = l "monitor_self";
            persistent = true;
            default = true;
          }
        ];
      }

      {
        _args = [
          {
            workspace = 1;
            monitor = l "asus";
            persistent = true;
            default = true;
          }
        ];
      }
    ];
  };

  defaultWorkspaces = {
    browser = 1;
    pip = 1;
  };
}
