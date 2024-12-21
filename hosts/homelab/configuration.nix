{ modulesPath
, inputs
, pkgs
, ...
}:

{
  imports =
    [
      ../../modules/nixos
      ./disk-config.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  users.cethien.enable = true;

  services.ssh.enable = true;

  virt.docker = {
    enable = true;
    users = [ "cethien" ];
    swarmFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."cethien" = import ./home.nix;
    backupFileExtension = "hm-backup-$(date +%Y%m%d_%H%M%S)";
  };
}
