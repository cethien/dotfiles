{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkBefore mkEnableOption;
  cfg = config.programs.bash;
in {
  options.programs.bash = {
    blesh.enable = mkEnableOption "ble.sh";
    sourceNixProfile =
      mkEnableOption "Whether to add nix profile loading to bash init. for when on non-NixOS distro";
  };

  config.programs.bash = {
    initExtra = mkIf cfg.blesh.enable (mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '');

    bashrcExtra = mkIf cfg.sourceNixProfile (mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '');
  };
}
