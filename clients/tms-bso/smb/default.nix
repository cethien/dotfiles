{
  pkgs,
  lib,
  config,
  utils,
  ...
}: let
  cfg = config.services.tms-shares;

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
  mountPath = name: "${cfg.path}/${formatMountName name}";

  automountUnitName = name: "${utils.escapeSystemdPath (mountPath name)}.automount";
  allAutomountUnits = map automountUnitName shareNames;
  u = config.users.users.cethien;
in {
  options.services.tms-shares = {
    enable = lib.mkEnableOption "smb shares";

    automount = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Aktiviert die Automounts direkt beim Systemstart.";
    };

    path = lib.mkOption {
      type = lib.types.str;
      default = "${u.home}/shares";
      description = "where";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."smb_credentials" = {};

    environment.systemPackages =
      [pkgs.cifs-utils]
      ++ lib.optionals (!cfg.automount) [
        (pkgs.writeShellScriptBin "smb-on" ''
          echo "Activating SMB automounts under ${cfg.path}..."
          sudo systemctl start ${toString allAutomountUnits}
        '')

        (pkgs.writeShellScriptBin "smb-off" ''
          echo "Deactivating and disconnecting SMB shares..."
          sudo systemctl stop ${toString allAutomountUnits}
        '')
      ];

    systemd.mounts =
      map (name: {
        where = mountPath name;
        what = "//10.102.99.213/${name}$";
        type = "cifs";
        options = "credentials=${config.sops.secrets."smb_credentials".path},uid=1000,gid=100,vers=3.0,rw,user";
        unitConfig = {
          Description = "Mount ${name}";
        };
      })
      shareNames;

    systemd.automounts =
      map (name: {
        where = mountPath name;
        wantedBy = lib.mkIf cfg.automount ["multi-user.target"];
        unitConfig = {
          Description = "Automount ${name}";
        };
      })
      shareNames;

    systemd.tmpfiles.rules =
      map (
        name: "d ${mountPath name} 0755 ${u.name} users -"
      )
      shareNames;
  };
}
