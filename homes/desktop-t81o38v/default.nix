{lib, ...}: let
  inherit (lib) mkBefore;
in {
  imports = [
    ../../modules/home
  ];

  accounts.email.accounts = import ./email.nix;

  programs = let
    sourceNix = ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
  in {
    firefox.enable = true;
    thunderbird.enable = true;
    thunderbird.profiles."b.sotnikow@tmsproshop.de".isDefault = true;
    ssh.matchBlocksExtra = import ./ssh.nix;
    freerdp.enable = true;
    freerdp.connections = import ./rdp.nix;
    bash.bashrcExtra = mkBefore sourceNix;
    zsh.initContent = mkBefore sourceNix;
  };
}
