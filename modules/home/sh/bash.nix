{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      export PATH=$GOBIN:$PATH
      source $(blesh-share)/ble.sh
    '';
  };

  home.packages = with pkgs; [
    blesh
  ];
}
