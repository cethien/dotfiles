{
  imports = [
    ../../modules/home
    ./email.nix
    ./smb.nix
    ./ssh.nix
  ];

  programs = {
    firefox.enable = true;
    thunderbird.enable = true;

    freerdp.enable = true;
    freerdp.connections = import ./rdp.nix;
    bash.bashrcExtra = ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
    gemini-cli.enable = true;
  };
}
