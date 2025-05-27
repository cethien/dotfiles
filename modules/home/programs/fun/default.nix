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
      (writeShellScriptBin "hyprland-cmatrix" (builtins.readFile ./hyprland-cmatrix.sh))

      fortune
      asciiquarium-transparent
      hackertyper

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

    programs.bash.initExtra = ''
      fortune | cowthink -C | dotacat
    '';
  };
}
