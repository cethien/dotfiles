let
  formattingLocale = "de_DE.UTF-8";
in
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = formattingLocale;
    LC_IDENTIFICATION = formattingLocale;
    LC_MEASUREMENT = formattingLocale;
    LC_MONETARY = formattingLocale;
    LC_NAME = formattingLocale;
    LC_NUMERIC = formattingLocale;
    LC_PAPER = formattingLocale;
    LC_TELEPHONE = formattingLocale;
    LC_TIME = formattingLocale;
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.useXkbConfig = true;

  deeznuts = {
    nix.enable = true;
    nixpkgs.allowUnfree = true;

    users.cethien.enable = true;
  };
}
