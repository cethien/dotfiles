{
  imports = [
    ../../modules/home
    ./smb.nix
    ./email.nix
    ./zen-browser.nix
    ./ssh.nix
    ./rdp.nix
  ];

  programs = {
    thunderbird.enable = true;

    bash.bashrcExtra = ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  };
}
