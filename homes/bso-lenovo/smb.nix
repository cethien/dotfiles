{config, ...}: let
  shareNames = [
    "Austausch"
    "Economy"
    "Keepass 2"
    "Keepass 3"
    "Privatlaufwerk BSO"
    "Media"
    "Produktbilder"
  ];
in {
  sops.secrets."rclone_smb_pass" = {
    sopsFile = ./secrets.yaml;
    format = "yaml";
  };

  programs.rclone.enable = true;
  programs.rclone.remotes."shares" = {
    config = {
      type = "smb";
      host = "10.102.99.213";
      user = "b.sotnikow";
      domain = "ad.tmsproshop.de";
    };
    secrets.pass = config.sops.secrets."rclone_smb_pass".path;

    mounts = builtins.listToAttrs (map (name: {
        name = "${name}$";
        value = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/Shares/${name}";
          options = {
            vfs-cache-mode = "full";
            dir-cache-time = "5000h";
            poll-interval = "10s";
            umask = "002";
          };
        };
      })
      shareNames);
  };
}
