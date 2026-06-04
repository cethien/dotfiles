{
  pkgs,
  config,
  ...
}: let
  monitors = {
    self = "eDP-1";
    eizo = "desc:Eizo Nanao Corporation EV2430 33096078";
  };
in {
  imports = [
    ./home
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland = {
    settings = with monitors; {
      monitor = [
        "${eizo}, 1920x1200@60, 0x0, 1"
        "${self}, 1920x1080@60, 1920x0, 1"
      ];
      general.allow_tearing = true;

      workspace = [
        "1, monitor:${eizo}, persistent:true, layout:master, default:true"
        "2, monitor:${eizo}, persistent:true, layout:master "
        "3, monitor:${eizo}, persistent:true"

        "4, monitor:${self}, persistent:true, default:true"
      ];
    };
    defaultWorkspaces.browser = 2;
  };
  programs.hyprlock.monitor = "${monitors.self}";

  home.packages = with pkgs; [
    simple-scan
    drawio
    rustdesk-flutter
    dbeaver-bin
    winboat
  ];

  services.davmail.enable = true;

  programs = {
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;
    keepassxc.enable = true;

    git.settings = import ./home/git.nix;
    ssh.settings = import ./home/ssh.nix // {"Host *".IdentityFile = "~/.ssh/id_ed25519";};
    freerdp.enable = true;
    freerdp.connections = import ./home/rdp.nix;
  };
}
