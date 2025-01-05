{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkBefore;
  cfg = config.deeznuts.programs.bash;
in
{
  options = {
    deeznuts.programs.bash = {
      sourceNixProfile = mkEnableOption "Whether to add nix profile loading to bash init. for when on non-NixOS distro";
    };
  };

  config = mkIf cfg.sourceNixProfile {
    programs.bash.bashrcExtra = mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  };
}
