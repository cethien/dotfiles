{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.programs.fun;
in {
  options.programs.fun = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "fullscreen, class:^(cmatrix)$"
      ];
      bind = [
        "SUPER SHIFT, Z, exec, ${
          (pkgs.cethien.writeHyprlandTermLaunchScriptBin "cmatrix").bin
        }"
      ];
    };

    home.packages = with pkgs; [
      cmatrix
      asciiquarium-transparent
      hackertyper
      ttysvr
      cowsay
      figlet
      dotacat
    ];

    home.shellAliases = {
      lolcat = "dotacat";
      matrix = "cmatrix";
      pipes = "${pkgs.pipes-rs}/bin/pipes-rs";
      sl = "${pkgs.sl}/bin/sl | ${pkgs.lolcat}/bin/lolcat && clear";
      fortune = ''
        ${pkgs.fortune}/bin/fortune cookie | cowthink -e "$(printf "oo\n**\n__\n^^\n$$\n@@\n==\nxx\n..\n" | shuf | head -n 1)" -C | dotacat
      '';
    };
  };
}
