{lib, ...}: let
  inherit (lib) mkDefault mkBefore;
in {
  home.username = mkDefault "cethien";
  home.homeDirectory = mkDefault "/home/cethien";
  programs.bash.bashrcExtra = mkBefore ''
    if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
      source ~/.nix-profile/etc/profile.d/nix.sh
    fi
  '';
}
