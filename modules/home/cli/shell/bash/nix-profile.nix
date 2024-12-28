{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkBefore;
  cfg = config.programs.bash.sourceNixProfile;
in
{
  options = {
    programs.bash.sourceNixProfile = {
      enable = mkEnableOption "Whether to add nix profile loading to bash init. for when on non-NixOS distro";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.bashrcExtra = mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  };
}
