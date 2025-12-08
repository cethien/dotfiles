{lib, ...}: let
  inherit (lib) mkBefore;
in {
  imports = [
    ../../modules/home
  ];

  programs = let
    sourceNix = ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  in {
    bash.bashrcExtra = mkBefore sourceNix;
    zsh.initContent = mkBefore sourceNix;
  };
}
