{ pkgs,... }:

{
  programs.bash = {
    enable = true;

    profileExtra = ''
        if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
          source "$HOME"/.nix-profile/etc/profile.d/nix.sh;
        fi

        if [ -e /usr/local/bin/ssh-agent-pipe ]; then
          source /usr/local/bin/ssh-agent-pipe;
        fi
    '';

    initExtra = ''
      export PATH=$GOBIN:$PATH
      source $(blesh-share)/ble.sh
    '';
  };

  home.packages = with pkgs; [
    blesh
  ];
}