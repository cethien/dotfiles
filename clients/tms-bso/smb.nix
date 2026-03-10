{
  pkgs,
  lib,
  config,
  ...
}: let
  shareNames = [
    "Austausch"
    "Economy"
    "Keepass 2"
    "Keepass 3"
    "Privatlaufwerk BSO"
    "Media"
    "Produktbilder"
  ];

  formatMountName = name: lib.toLower (builtins.replaceStrings [" "] ["-"] name);
  mountPath = name: "/home/bsotnikow/shares/${formatMountName name}";
  mountUnitName = name: lib.utils.escapeSystemdPath (mountPath name);
in {
  sops.secrets."smb_credentials" = {
    sopsFile = ./secrets.yml;
    format = "yaml";
  };

  environment.systemPackages = [pkgs.cifs-utils];
  systemd.mounts =
    map (name: {
      where = mountPath name;
      what = "//10.102.99.213/${name}$";
      type = "cifs";
      options = "credentials=${config.sops.secrets.smb_credentials.path},uid=1000,gid=100,vers=3.0,rw,user";
      unitConfig = {
        Description = "Mount ${name}";
      };
    })
    shareNames;

  systemd.automounts =
    map (name: {
      where = mountPath name;
      wantedBy = ["multi-user.target"];
      unitConfig = {
        Description = "Automount ${name}";
      };
    })
    shareNames;

  systemd.tmpfiles.rules =
    map (
      name: "d ${mountPath name} 0755 bsotnikow users -"
    )
    shareNames;
}
