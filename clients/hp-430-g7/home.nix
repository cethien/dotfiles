{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../_common/home/cethien
  ];

  stylix.image = ../_common/home/wallpapers/boy_and_cat_sitting_on_stairs.jpeg;
  wayland.windowManager.hyprland.extraLuaFiles."50-hp-430-g7" =
    # lua
    ''
      hl.monitor({
          output = "eDP-1",
          mode = "1920x1080@60",
          position = "0x0",
          scale = 1,
      })
    '';
  programs.hyprlock.monitor = "eDP-1";

  home.packages = with pkgs; [
    simple-scan
    ausweisapp
    mixxx
    qlcplus
  ];

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
