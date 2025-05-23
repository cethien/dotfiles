{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fun;
in
{
  options.deeznuts.programs.fun = {
    enable = mkEnableOption "some utils with no use but kinda cool";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fortune
      asciiquarium-transparent
      hackertyper

      cowsay
      figlet
      dotacat
    ];

    home.shellAliases = {
      lolcat = "dotacat";
      matrix = "${pkgs.cmatrix}/bin/cmatrix";
      pipes = "${pkgs.pipes-rs}/bin/pipes-rs";
      sl = "${pkgs.sl}/bin/sl | ${pkgs.lolcat}/bin/lolcat && clear";
    };

    programs.bash.initExtra = ''
      fortune | cowthink -C | dotacat
    '';

    programs.cava.enable = true;
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
        # foregrund = "#61AFEF";
        theme = "tricolor";
      };
    };
  };
}
