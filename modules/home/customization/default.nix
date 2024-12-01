{ pkgs,...}: 
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };  

  gtk = {
    enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      size = "standard";
      tweaks = [ "normal" ];
    };

    iconTheme = {
      name = "Tela-purple-dark";
      package = pkgs.tela-icon-theme;
    };

    cursorTheme = {
      name  = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
    };

  };

  qt = {
    enable = true;

    platformTheme.name = "kvantum";
    style.name = "kvantum";
    style.package = pkgs.catppuccin-qt5ct;
  };

  home.packages = with pkgs; [
    roboto
    open-sans
    
    nerd-fonts.fira-code
    nerd-fonts.code-new-roman
  ];

}