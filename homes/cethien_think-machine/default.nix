{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;
    stylix.enable = true;
    desktop.hyprland = {
      enable = true;
      monitors = [
        "eDP-1, 1366x768@60, 0x0, 1"
      ];

      workspaces = [
        "1, monitor:eDP-1, persistent:true, default:false"
        "2, monitor:eDP-1, persistent:true, default:true"
        "3, monitor:eDP-1, persistent:true, default:false"
        "4, monitor:eDP-1, persistent:true, default:false"
        "5, monitor:eDP-1, persistent:true, default:false"
      ];
    };
    programs = {
      cli.enable = true;
      basic.enable = true;
      gaming.enable = true;
      discord.enable = true;
      obs-studio.enable = true;
      firefox-devedition.enable = true;
    };
  };
}
