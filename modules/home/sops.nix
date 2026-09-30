{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.programs.sops;

  initSops = pkgs.writers.writePython3Bin "init-sops" {
    libraries = [pkgs.python3Packages.pyyaml];
  } (builtins.readFile ./init-sops.py);
in {
  options.programs.sops = {
    enable = lib.mkEnableOption "sops and helper tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      sops
      age
      ssh-to-age
      initSops
    ];
  };
}
