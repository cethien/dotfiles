{
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  config = {
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur on, match:namespace rofi"
        "dim_around on, match:namespace rofi"
      ];
    };
    programs.rofi = {
      extraConfig = {
        modi = "drun";
        show-icons = false;
        display-drun = " ";
        drun-display-format = "{name}";
      };
      theme = {
        "window" = {
          width = mkLiteral "calc( 100% min 72% )";
          expand = false;
          transparency = "real";
          border = mkLiteral "4px solid";
          border-radius = mkLiteral "6px";
          border-color = mkLiteral "@active-foreground";
        };

        "mainbox" = {
          spacing = mkLiteral "20px";
          margin = mkLiteral "0px";
          padding = mkLiteral "8px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "0px 0px 0px 0px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "transparent";
          children = map mkLiteral ["inputbar" "listview"];
        };

        "inputbar" = {
          spacing = mkLiteral "40px";
          padding = mkLiteral "12px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "@background-color";
          children = map mkLiteral ["prompt" "entry"];
        };

        "prompt" = {
          background-color = mkLiteral "inherit";
          # text-color = mkLiteral "inherit";
        };

        "entry" = {
          background-color = mkLiteral "inherit";
          # text-color = mkLiteral "inherit";
          cursor = mkLiteral "text";
          placeholder = "search";
          placeholder-color = mkLiteral "inherit";
        };

        "listview" = {
          dynamic = false;
          fixed-height = true;
          lines = 9;
          scrollbar = false;
          spacing = mkLiteral "2px";
          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "4px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = "default";
        };

        "element" = {
          spacing = mkLiteral "4px";
          margin = mkLiteral "6px 2px";
          padding = mkLiteral "6px 10px";
          background-color = mkLiteral "transparent";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "4px";
          border-color = mkLiteral "@selected-normal-foreground";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "pointer";
        };

        "element normal.normal".background-color = mkForce (mkLiteral "transparent");
        "element alternate.normal".background-color = mkForce (mkLiteral "transparent");
        "element alternate.urgent".background-color = mkForce (mkLiteral "transparent");
        "element alternate.active".background-color = mkForce (mkLiteral "transparent");

        "element selected.normal" = {
          border = mkLiteral "0px";
          border-radius = mkLiteral "6px";
          border-color = mkLiteral "@selected-normal-foreground";
        };

        "element-icon" = {
          background-color = mkForce (mkLiteral "transparent");
          text-color = mkLiteral "inherit";
          size = mkLiteral "32px";
          cursor = mkLiteral "inherit";
        };

        "element-text" = {
          background-color = mkForce (mkLiteral "transparent");
          text-color = mkLiteral "inherit";
          highlight = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          text-transform = mkLiteral "lowercase";
          padding = "0px 0px 0px 4px";
          vertical-align = mkLiteral "0.5";
        };
      };
    };
  };
}
