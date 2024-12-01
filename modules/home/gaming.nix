{ pkgs,... }:

{
  programs = {
    mangohud = {
      enable = true;
      settings = {
        fps_only = true;
      };
    };
  };

  home.packages = with pkgs; [
    prismlauncher
  ];
}