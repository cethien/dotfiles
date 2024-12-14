{ lib, config, pkgs, ... }:

{
  options.user.dev.ansible.enable = lib.mkEnableOption "Enable ansible";

  config = lib.mkIf config.user.dev.ansible.enable {
    home.packages = with pkgs; [
      ansible
      ansible-lint
      sshpass
    ];
  };
}