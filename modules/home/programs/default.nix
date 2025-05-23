{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption mkMerge mkDefault;
  cfg = config.deeznuts.programs;
in
{
  options.deeznuts.programs = {
    cli.enable = mkEnableOption "Enable all cli programs";
    basic.enable = mkEnableOption "Enable basic desktop programs";
    gaming.enable = mkEnableOption "Enable gaming related programs";
  };

  imports = [
    ./gaming/pokemmo.nix
    ./aliases
    ./bash
    ./bat
    ./bc
    ./bottom
    ./dev/dblab.nix
    ./dev/direnv.nix
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
    ./hyprland
    ./imv
    ./inkscape
    ./jq
    ./keepassxc
    ./dev/lazydocker.nix
    ./dev/lazygit.nix
    ./dev/chromium.nix
    ./lynx
    ./gaming/mangohud.nix
    ./common-utils.nix
    ./mpv
    ./neovim
    ./nmap
    ./obs-studio
    ./ocenaudio
    ./oh-my-posh
    ./pavucontrol
    ./pinta
    ./poppler
    ./gaming/prismlauncher.nix
    ./procs
    ./gaming/r2modman.nix
    ./gaming/retroarch.nix
    ./ripgrep
    ./rnote
    ./scripts
    ./spotify
    ./ssh
    ./gaming/steam.nix
    ./termshark
    ./tmux
    ./dev/vscode.nix
    ./yazi
    ./zen-browser.nix
    ./zoxide
    ./dev/jetbrains.nix
    ./fun.nix
  ];

  config = mkMerge [
    (mkIf cfg.cli.enable {
      deeznuts.programs = {
        fun.enable = mkDefault true;
        aliases.enable = mkDefault true;
        bash.enable = mkDefault true;
        bat.enable = mkDefault true;
        bc.enable = mkDefault true;
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
        common-utils.enable = mkDefault true;
        neovim.enable = mkDefault true;
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
        lynx.enable = mkDefault true;
      };
    })
    (mkIf cfg.basic.enable {
      deeznuts.programs = {
        pavucontrol.enable = mkDefault true;
        easyeffects.enable = mkDefault true;

        zen-browser.enable = mkDefault true;
        discord.enable = mkDefault true;
        spotify.enable = mkDefault true;

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
        mangohud.enable = mkDefault true;
        steam.enable = mkDefault true;
        r2modman.enable = mkDefault true;
        retroarch.enable = mkDefault true;
        prismlauncher.enable = mkDefault true;
        pokemmo.enable = mkDefault true;
      };
    })
  ];
}
