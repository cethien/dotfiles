{
  config,
  lib,
  pkgs,
  ...
}: let
  monitors = {
    self = "eDP-1";
    asus = "desc:ASUSTek COMPUTER INC VG27AQML1A S9LMQS167913";
    arzopa = "desc:GWD ARZOPA 000000000001";
    eizo = "desc:Eizo Nanao Corporation EV2430 33096078";
  };
in {
  imports = [
    ../_common/home/cethien
  ];

  stylix.image = ../_common/home/wallpapers/boy_and_cat_sitting_on_stairs.jpeg;
  wayland.windowManager.hyprland = import ./hyprland-settings.nix {
    inherit lib monitors;
    hLib = config.lib.deeznuts.hyprland;
  };
  programs.hyprlock.monitor = "${monitors.self}";

  home.packages = with pkgs; [simple-scan ausweisapp mixxx qlcplus];

  programs.zen-browser.profiles."${config.home.username}" = let
    containers = {
      logged-out = {
        id = 1;
        color = "toolbar";
        icon = "chill";
      };
      admin = {
        id = 2;
        color = "pink";
        icon = "circle";
      };
      "tmsproshop.de" = {
        id = 3;
        color = "green";
        icon = "briefcase";
      };
      "tmsproshop.de/admin" = {
        id = 4;
        color = "purple";
        icon = "briefcase";
      };
    };

    spaces."on deez road again" = {
      id = "1d6bd4a3-319b-4782-b201-cfb3bd230a90";
      position = 1000;
      icon = "🚄";
    };
  in {
    containersForce = true;
    inherit containers;
    spacesForce = true;
    inherit spaces;
  };

  programs = {
    rclone.enable = true;

    zen-browser.enable = true;
    freerdp.enable = true;
    freerdp.connections = import ../tms-bso/home/rdp.nix;
    ssh.settings =
      (import ../_common/home/ssh.nix)
      // {
        "Match host 10.*" = {
          User = "bsotnikow";
          IdentityFile = "~/.ssh/id_ed25519_tmsproshop_bsotnikow";
        };
      }
      // (import ../tms-bso/home/ssh.nix);
  };
}
