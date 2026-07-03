{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland.extraLuaFiles = {
    "50-tms-bso".content = ./hyprland-tms-bso.lua;
  };

  programs.hyprlock.monitor = "eDP-1";

  home.packages = with pkgs; [
    simple-scan
    drawio
    rustdesk-flutter
    winboat
  ];

  services.davmail.enable = true;

  programs = {
    dbeaver.enable = true;
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;

    spicetify.enable = true;
    spotify-player.enable = lib.mkForce false;
    zen-browser = import ./zen-browser.nix {inherit config pkgs;};

    git.settings = import ../_tms/home/git.nix;
    ssh.settings =
      import ../_tms/home/ssh.nix
      // {
        "Host *".IdentityFile = "~/.ssh/id_ed25519";
      };
    freerdp.enable = true;
    freerdp.connections = import ../_tms/home/rdp.nix;

    pvetui.settings = {
      profiles = let
        settings = {
          token_id = "";
          token_secret = "";
          api_path = "/api2/json";
          insecure = true;
          groups = ["tms"];
          ssh_user = "root";
          vm_ssh_user = "${config.home.username}";
        };
      in {
        cluster =
          settings
          // {
            addr = "https://10.0.10.5:8006";
            realm = "pve";
            user = "${config.home.username}";
            password = "age1:YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBPVTFpemY4REdjNnczbUxSVGpXeTAxUU9aeFhrT0lZdS9TWC9WTmVrSEVjClYrSWEwQUdVYkdwMnBCK3VFbTdHa3hISkdGaEdWRk01b0dZY05zYnAyc1UKLS0tIDl2SUdzSi9MTmpuZFBDaFd1NXpKUWhrNTRuV1RPWnprT2VxeXcxL1ViSHcKumjTLYIJzwJ//5G5bLZbrL4nciN6Wqtf+lpPRc/N3cKLVrKFWfBd8kx5";
          };
        node-c =
          settings
          // {
            addr = "https://10.0.10.7:8006";
            realm = "pam";
            user = "root";
            password = "age1:YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSA1WW96QUdUTTE2L3Q0NzN0SC9NVVVnVWRweFhlNy9nOHBabityVDNGN2lRCmJLL1Vzc051alpEUHlNK2Rhc0hVbXdweTd1azNZeS9nWjdPTGNQUlhKRTAKLS0tIDkwUG45SEdCMURJSGlWbFZYeVBLR3BZQll0RlBjQWZWUDBua0JCWG9FU0EKwOijF0DczkFxeXRED61gNOkusuIF4YgJcemxTTv+1gQOZk4UAu9O8pQgaYlRZv1b0R30ga8f2eA=";
          };
      };
      default_profile = "tms";
      group_settings = {
        tms.mode = "aggregate";
      };
    };
  };
}
