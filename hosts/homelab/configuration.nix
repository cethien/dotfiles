{ modulesPath
, inputs
, meta
, ...
}:

{
  imports =
    [
      ../../modules/nixos

      (modulesPath + "/installer/scan/not-detected.nix")

      ./disk-config.nix
    ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

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
