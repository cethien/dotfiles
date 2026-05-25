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
    ../_common/home.nix

    ./email.nix
    ./ssh.nix
    ./rdp.nix
    ./zen-browser.nix
  ];

  stylix.image = ../../wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = with monitors; {
      monitor = [
        "${eizo}, 1920x1200@60, 0x0, 1"
        "${self}, 1920x1080@60, 1920x0, 1"
      ];
      general.allow_tearing = true;

      workspace = [
        "1, monitor:${eizo}, persistent:true, default:true, layout:master"
        "2, monitor:${eizo}, persistent:true"
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
    omnissa-horizon-client
  ];

  services.davmail.enable = true;

  programs = {
    slack.enable = true;
    thunderbird.enable = true;
    libreoffice.enable = true;
    keepassxc.enable = true;
    container-tools.enable = true;
    freerdp.enable = true;
  };
}
