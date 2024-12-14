{ pkgs, system, ... }:

{
  programs.bash = {
    enable = true;

    profileExtra =
      if system.profile.isWSL then ''
        if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
          source "$HOME"/.nix-profile/etc/profile.d/nix.sh;
        fi
      '' else "";

    initExtra = ''
      export PATH=$GOBIN:$PATH
      source $(blesh-share)/ble.sh
    '';
  };

  home.packages = with pkgs; [
    blesh
  ];
}
