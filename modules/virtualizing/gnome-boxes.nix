{ lib, config, pkgs, ... }:

{
  options.virtualizing.gnome-boxes.enable = lib.mkEnableOption "Enable gnome-boxes";

  config = lib.mkIf config.virtualizing.gnome-boxes.enable {
    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-boxes
    ];
  };
}