{
  imports = [
    ../../modules/home
  ];

  accounts.email.accounts = import ./email.nix;

  programs = {
    firefox.enable = true;
    thunderbird.enable = true;
    thunderbird.profiles."b.sotnikow@tmsproshop.de".isDefault = true;
    ssh.matchBlocksExtra = import ./ssh.nix;
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
