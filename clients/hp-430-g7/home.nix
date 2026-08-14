{
  config,
  lib,
  pkgs,
  ...
}: let
  tmsSsh = import ../_tms/home/ssh.nix {inherit pkgs;};
in {
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

    tms = import ../_tms/home/zen-browser.nix {inherit pkgs;};
  in {
    bookmarks = {
      force = true;
      settings = tms.bookmarks;
    };
    extensions.packages = tms.extensions;

    containersForce = true;
    inherit containers;
    spacesForce = true;
    inherit spaces;
  };

  programs = {
    freerdp.enable = true;
    freerdp.connections = import ../_tms/home/rdp.nix;
    ssh.includes = [
      (tmsSsh.asIncludePath {
        User = "bsotnikow";
        IdentityFile = "~/.ssh/id_ed25519_tmsproshop_bsotnikow";
        IdentitiesOnly = "yes";
      })
    ];

    rclone.enable = true;
    ssh.settings = import ../_common/home/ssh.nix;
  };
}
