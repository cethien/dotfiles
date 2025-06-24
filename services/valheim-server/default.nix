{
  networking.firewall = {
    allowedUDPPorts = [2456 2457];
  };

  systemd.tmpfiles.rules = [
    "d /opt/valheim 0755 root root"
  ];
}
