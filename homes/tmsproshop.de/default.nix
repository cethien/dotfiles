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
    # freerdp.connections = let
    #   domain = "ad.tmpsproshop.de";
    #   username = "Administrator";
    # in {
    #   "hyper-v" = {
    #     inherit domain username;
    #     "full address" = "10.102.99.89";
    #   };
    #
    #   "ad" = {
    #     inherit domain username;
    #     "full address" = "10.102.99.98";
    #   };
    #
    #   "exchange" = {
    #     inherit domain username;
    #     "full address" = "10.102.99.99";
    #   };
    #   "timas" = {
    #     "full address" = "10.180.80.155";
    #     username = "LocalAdmin";
    #     domain = "";
    #   };
    # };

    bash.bashrcExtra = mkBefore sourceNix;
    zsh.initContent = mkBefore sourceNix;
  };
}
