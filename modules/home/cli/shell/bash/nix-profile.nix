{ lib, config, pkgs, ... }:
let
  cfg = config.programs.bash.sourceNixProfile;
in
{
  options = {
    programs.bash.sourceNixProfile.enable = lib.mkEnableOption
      "Whether to add nix profile loading to bash init. for when on non-NixOS distro";
  };

  config = lib.mkIf cfg.enable {
    programs.bash.bashrcExtra = lib.mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  };
}
