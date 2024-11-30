{ config, pkgs, ... }:

{

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs = {
    git = {
     enable = true;
     userName = "cethien";
     userEmail = "borislaw.sotnikow@gmx.de";
    };
    tmux.enable = true;
    eza.enable = true;
    bat.enable = true;
    oh-my-posh = {
      enable = true;
      useTheme = "catppuccin_mocha";
    };
  };
  
  home.packages = with pkgs; [
    cowsay
    lolcat
  ];
}
