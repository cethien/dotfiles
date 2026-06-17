{
  hLib,
  lib,
  monitors,
  ...
}: {
  defaultWorkspaces = {
    browser = 1;
    pip = 1;
  };

  settings = let
    l = lib.generators.mkLuaInline;
  in {
    lpt_main._var = monitors.self;
    eizo._var = monitors.eizo;

    config.general.allow_tearing = true;
    monitor = [
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
            output = l "lpt_main";
            mode = "1920x1080@60";
            position = "1920x0";
            scale = 1;
          }
        ];
      }
    ];

    on = [(hLib.mkAutostart "slack -u" {})];
    bind = [(hLib.mkExecBind "SUPER + F12" "slack" {})];
    window_rule = [(hLib.mkWindowRule {initial_class = "^(DBeaver)$";} {tile = true;})];

    workspace_rule = [
      {
        _args = [
          {
            workspace = 1;
            monitor = l "eizo";
            persistent = true;
            default = true;
          }
        ];
      }
      {
        _args = [
          {
            workspace = 5;
            monitor = l "lpt_main";
            persistent = true;
            default = true;
          }
        ];
      }
    ];
  };
}
