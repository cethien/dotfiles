{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
  ];

  networking.hostName = "booty";

  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
    htop

    nmap
    iperf3
    tcpdump
    bind.dnsutils
    ethtool
    ipmitool

    pciutils
    usbutils
    smartmontools
  ];

  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  console.keyMap = "de-latin1-nodeadkeys";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  security.sudo.wheelNeedsPassword = false;
  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    warn-dirty = false;
    trusted-users = ["@wheel"];
    allowed-users = ["@wheel"];
  };
}
