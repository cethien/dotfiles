{
  networking.firewall = {
    allowedTCPPorts = [25565];
  };

  systemd.tmpfiles.rules = [
    "d /opt/minecraft 0755 root root"
  ];
}
