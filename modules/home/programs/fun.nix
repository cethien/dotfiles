{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fun;
in {
  options.deeznuts.programs.fun = {
    enable = mkEnableOption "some utils with no use but kinda cool";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "fullscreen, class:^(cmatrix)$"
      ];
      bind = [
        "SUPER SHIFT, Z, exec, hyprland-cmatrix"
      ];
    };

    home.packages = with pkgs; [
      cmatrix
      (writeShellScriptBin "hyprland-cmatrix" ''
        #!/usr/bin/env bash
        hyprctl clients | grep -q 'class:.*cmatrix' &&
          hyprctl dispatch focuswindow class:cmatrix ||
          kitty --class cmatrix -e cmatrix &
      '')
      asciiquarium-transparent
      hackertyper
      ttysvr

      fortune
      cowsay
      figlet
      dotacat
    ];

    home.shellAliases = {
      lolcat = "dotacat";
      matrix = "cmatrix";
      pipes = "${pkgs.pipes-rs}/bin/pipes-rs";
      sl = "${pkgs.sl}/bin/sl | ${pkgs.lolcat}/bin/lolcat && clear";
    };

    programs.bash.initExtra =
      # bash
      ''
        fortune cookie | cowthink -e "$(printf "oo\n**\n__\n^^\n$$\n@@\n==\nxx\n..\n" | shuf | head -n 1)" -C | dotacat
      '';
  };
}
