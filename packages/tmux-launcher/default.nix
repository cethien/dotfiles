{pkgs}: let
  basePkg = pkgs.buildGoModule {
    pname = "tmux-launcher";
    version = "0.1.0";

    src = ./.;

    vendorHash = "sha256-1xFQcvEunwEMbd2mAB58vTxCxaM8sh20wYQvFUZXaTA=";

    meta = {
      description = "Tmux & fzf launcher with custom previews";
      mainProgram = "tmux-launcher";
    };
  };
in
  pkgs.symlinkJoin {
    name = "tmux-launcher";
    paths = [basePkg];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/tmux-launcher \
        --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
        fzf
        tmux
        openssh
        gawk
        gnugrep
        coreutils
        procps
      ])}
    '';
  }
