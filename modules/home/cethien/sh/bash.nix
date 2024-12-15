{ config, pkgs, system, ... }:

{
  programs.bash = {
    enable = true;

    profileExtra =
      if system.profile.isWSL then ''
        if [ -e "${config.home.homeDirectory}"/.nix-profile/etc/profile.d/nix.sh ]; then
          source "${config.home.homeDirectory}"/.nix-profile/etc/profile.d/nix.sh;
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
