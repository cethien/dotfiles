{ modulesPath
, inputs
, ...
}:

{
  imports =
    [
      ../../modules/nixos
      ./disk-config.nix
      ./hardware-configuration.nix
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ];

  users = {
    cethien.enable = true;
  };

  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  hardware = {
    bluetooth.enable = true;
    pipewire.enable = true;
  };

  desktop-environment.gnome.enable = true;
  theming = {
    catppuccin.enable = true;
    fonts.enable = true;
  };

  virt = {
    docker.enable = true;
    docker.liveRestore = true;
    docker.users = [ "cethien" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."cethien" = import ./home.nix;
    backupFileExtension = "hm-backup-$(date +%Y%m%d_%H%M%S)";
  };
}
