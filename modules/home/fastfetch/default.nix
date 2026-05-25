{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.programs.fastfetch;
  c = config.lib.stylix.colors;

  settings = {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      type = "kitty";
      source = toString cfg.logo;
      height = 20;
      padding = {
        top = 1;
        left = 1;
        right = 1;
      };
    };

    display = {
      separator = "";
      constants = ["──────────────"];
      key = {
        width = 10;
      };
    };

    modules = [
      {
        type = "custom";
        format = "{#90}┌{$1} Hardware {$1}{$1}┐{#}";
      }
      {
        key = "CPU";
        type = "cpu";
        showPeCoreCount = true;
        keyColor = "33";
      }
      {
        key = "GPU";
        type = "gpu";
        keyColor = "32";
      }
      {
        key = "Display";
        type = "display";
        keyColor = "36";
      }
      {
        key = "Disk";
        type = "disk";
        folders = "/";
        keyColor = "34";
      }
      {
        key = "Disk";
        type = "disk";
        folders = "/home";
        keyColor = "94";
      }
      {
        key = "Memory";
        type = "memory";
        keyColor = "31";
      }
      {
        key = "Swap";
        type = "swap";
        keyColor = "95";
      }
      {
        type = "custom";
        format = "{#90}└{$1}────────────────────────{$1}┘{#}";
      }
      {
        type = "custom";
        format = "{#90}┌{$1} Software {$1}{$1}┐{#}";
      }
      {
        key = "Kernel";
        type = "kernel";
        keyColor = "93";
      }
      {
        key = "OS";
        type = "os";
        keyColor = "33";
      }
      {
        key = "DE";
        type = "de";
        keyColor = "91";
      }
      {
        key = "WM";
        type = "wm";
        keyColor = "32";
      }
      {
        key = "Theme";
        type = "theme";
        keyColor = "92";
      }
      {
        key = "Icons";
        type = "icons";
        keyColor = "36";
      }
      {
        key = "Font";
        type = "font";
        keyColor = "96";
      }
      {
        key = "Font";
        type = "terminalfont";
        keyColor = "34";
      }
      {
        type = "custom";
        format = "{#90}└{$1}────────────────────────{$1}┘{#}";
      }
    ];
  };
in {
  options.programs.fastfetch = {
    logo = mkOption {
      type = types.path;
      default = ./bernd_pixel.png; #
      description = "Pfad zum Logo-Bild für Fastfetch";
    };
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      inherit settings;
    };

    home.shellAliases.ff = "fastfetch";
  };
}
