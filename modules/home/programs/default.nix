{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption mkMerge mkDefault;
  cfg = config.deeznuts.programs;
in
{
  options.deeznuts.programs = {
    cli.enable = mkEnableOption "Enable all cli programs";
    basic.enable = mkEnableOption "Enable basic programs";
    gaming.enable = mkEnableOption "Enable gaming related programs";
  };

  imports = [
    ./aliases
    ./bash
    ./bat
    ./bottom
    ./dblab
    ./direnv
    ./discord
    ./drawio
    ./duf
    ./easyeffects
    ./eza
    ./fastfetch
    ./fd
    ./ffmpeg
    ./fzf
    ./gh
    ./gimp
    ./git
    ./hushlogin
    ./inkscape
    ./imv
    ./jq
    ./keepassxc
    ./kitty
    ./lazydocker
    ./lazygit
    ./mangohud
    ./misc
    ./mpv
    ./neovim
    ./netscanner
    ./nmap
    ./obs-studio
    ./ocenaudio
    ./oh-my-posh
    ./pinta
    ./poppler
    ./prismlauncher
    ./procs
    ./protonge
    ./r2modman
    ./retroarch
    ./ripgrep
    ./rnote
    ./rofi
    ./scripts
    ./spotify
    ./ssh
    ./steam
    ./termshark
    ./tmux
    ./vscode
    ./yazi
    ./zoxide
    ./zen
  ];

  config = mkMerge [
    (mkIf cfg.cli.enable {
      deeznuts.programs = {
        aliases.enable = mkDefault true;
        bash.enable = mkDefault true;
        bat.enable = mkDefault true;
        bottom.enable = mkDefault true;
        dblab.enable = mkDefault true;
        direnv.enable = mkDefault true;
        duf.enable = mkDefault true;
        eza.enable = mkDefault true;
        fastfetch.enable = mkDefault true;
        fd.enable = mkDefault true;
        ffmpeg.enable = mkDefault true;
        fzf.enable = mkDefault true;
        gh.enable = mkDefault true;
        git.enable = mkDefault true;
        hushlogin.enable = mkDefault true;
        jq.enable = mkDefault true;
        lazydocker.enable = mkDefault true;
        lazygit.enable = mkDefault true;
        misc.enable = mkDefault true;
        neovim.enable = mkDefault true;
        netscanner.enable = mkDefault true;
        oh-my-posh.enable = mkDefault true;
        nmap.enable = mkDefault true;
        poppler.enable = mkDefault true;
        procs.enable = mkDefault true;
        ripgrep.enable = mkDefault true;
        scripts.enable = mkDefault true;
        ssh.enable = mkDefault true;
        termshark.enable = mkDefault true;
        tmux.enable = mkDefault true;
        yazi.enable = mkDefault true;
        zoxide.enable = mkDefault true;
      };
    })
    (mkIf cfg.basic.enable {
      deeznuts.programs = {
        easyeffects.enable = mkDefault true;

        zen.enable = mkDefault true;
        spotify.enable = mkDefault true;
        vscode.enable = mkDefault true;
        keepassxc.enable = mkDefault true;

        pinta.enable = mkDefault true;
        gimp.enable = mkDefault true;
        inkscape.enable = mkDefault true;
        drawio.enable = mkDefault true;

        ocenaudio.enable = mkDefault true;
      };
    })
    (mkIf cfg.gaming.enable {
      deeznuts.programs = {
        steam.enable = mkDefault true;
        mangohud.enable = mkDefault true;
        protonge.enable = mkDefault true;
        r2modman.enable = mkDefault true;
        retroarch.enable = mkDefault true;
        prismlauncher.enable = mkDefault true;
      };
    })
  ];
}
