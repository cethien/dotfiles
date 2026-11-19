{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules
    ./caddy-cloudflare-tls.nix
    ./nix-deploy.nix
  ];

  config = {
    users.users.cethien.enable = true;

    nix-deploy.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    environment.systemPackages = with pkgs; [
      vim
      htop
      curl
      git

      htop
      sysstat
      sysz

      duf
      iotop
      ncdu

      fzf

      curl
      nettools
      iproute2
      traceroute
      mtr
      dig
      bmon
      nmap
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.trusted-users = ["@wheel"];

    networking.networkmanager.enable = lib.mkDefault true;

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "de-latin1-nodeadkeys";

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
