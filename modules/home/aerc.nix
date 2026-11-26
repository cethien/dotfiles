{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.aerc;
  execAerc = "${cfg.package}/bin/aerc";
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      w3m
      xdg-utils
    ];

    programs.aerc = {
      extraConfig = {
        general."unsafe-accounts-conf" = true;
        ui."mouse-enabled" = true;

        viewer = {
          alternatives = "text/html,text/plain";
          "html-inline-images" = true;
        };

        filters = {
          "text/plain" = "${cfg.package}/libexec/aerc/filters/colorize";
          "text/html" = "! ${cfg.package}/libexec/aerc/filters/html";
        };

        openers = {
          "text/html" = "sh -c '${pkgs.xdg-utils}/bin/xdg-open \"$1\" && sleep 2' _";
        };

        compose = {
          editor = "nvim";
          "focus-body" = true;
        };
        "multipart-converters"."text/html" = "${lib.getExe config.programs.pandoc.package} -f gfm -t html --standalone";
      };

      extraBinds = lib.mkMerge [
        (builtins.readFile "${cfg.package}/share/aerc/binds.conf")
        ''
          [messages]
          * = :flag -t<Enter>

          [compose::review]
          H = :multipart text/html<Enter>
          y = :multipart text/html<Enter>:send<Enter>
          P = :send<Enter>
        ''
      ];
    };

    programs.tmux.keybindings = [
      {
        key = "m";
        action = "new-window -an aerc ${execAerc}";
      }
    ];
  };
}
