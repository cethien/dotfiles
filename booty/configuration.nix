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
    disko
    (pkgs.writeShellScriptBin "nixos-here" (builtins.readFile ./nixos-here.sh))
    nixos-anywhere

    git
    neovim
    tmux
    htop

    bmon
    nmap
    iperf3
    tcpdump
    bind.dnsutils
    ethtool
    ipmitool

    pciutils
    usbutils
    smartmontools

    ntfs3g
    zfs
    nvme-cli

    (import ./check-nvme-wearout.nix {inherit pkgs;})
  ];

  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5zRzC541CDplODfOhYkTvInDnV4Muoh4KvASD5GQFR nix-deploy@holzrussen.net"
  ];

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
