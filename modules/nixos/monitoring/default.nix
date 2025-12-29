{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [./alloy-config.nix];
  config = {
    services.alloy = {
      enable = mkDefault false;
      extraFlags = [
        "--disable-reporting"
      ];
    };

    services.cadvisor = {
      enable = mkDefault false;
      extraOptions = [
        "--docker_only"
      ];
    };
  };
}
