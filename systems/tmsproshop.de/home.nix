{
  stateVersion,
  lib,
  ...
}: let
  inherit (lib) mkBefore;
  username = "bsotnikow";
in {
  imports = [
    ../../modules/home
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = stateVersion;

  programs = let
    gitServer = "git.tmspro.shop";
  in {
    bash.bashrcExtra = mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';

    ssh.matchBlocksExtra = {
      gitServer = {
        host = gitServer;
        hostname = gitServer;
        port = 2222;
      };
    };

    git.urlExtra = {
      "ssh://git@${gitServer}".insteadOf = "https://${gitServer}";
      "git@${gitServer}:".insteadOf = "local:";
    };
  };
}
