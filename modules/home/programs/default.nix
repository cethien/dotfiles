{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkDefault;
  cfg = config.deeznuts.programs;
in {
  options.deeznuts.programs = {
    cli.enable = mkEnableOption "Enable all cli programs";
    basic.enable = mkEnableOption "Enable basic desktop programs";
    gaming.enable = mkEnableOption "Enable gaming related programs";
  };

  imports = [
    ./shellAliases.nix
    ./bash
    ./bat.nix
    ./bc.nix
    ./bottom
    ./common-utils.nix
    ./dev/chromium.nix
    ./dev/dblab.nix
    ./dev/direnv.nix
    ./dev/jetbrains.nix
    ./dev/lazydocker.nix
    ./dev/lazygit.nix
    ./dev/vscode.nix
    ./discord.nix
    ./drawio.nix
    ./duf.nix
    ./easyeffects.nix
    ./eza.nix
    ./fastfetch
    ./fd.nix
    ./ffmpeg.nix
    ./fun.nix
    ./firefox.nix
    ./fzf.nix
    ./gaming/mangohud.nix
    ./gaming/pokemmo.nix
    ./gaming/prismlauncher.nix
    ./gaming/r2modman.nix
    ./gaming/retroarch.nix
    ./gaming/steam.nix
    ./gh.nix
    ./gimp.nix
    ./git.nix
    ./hushlogin.nix
    ./hyprland
    ./imv.nix
    ./inkscape.nix
    ./jq.nix
    ./keepassxc.nix
    ./lynx.nix
    ./markdown.nix
    ./mpv.nix
    ./neovim
    ./nmap.nix
    ./obs-studio.nix
    ./ocenaudio.nix
    ./oh-my-posh
    ./pavucontrol.nix
    ./pinta.nix
    ./poppler-utils.nix
    ./procs.nix
    ./ripgrep.nix
    ./rnote.nix
    ./scripts
    ./spotify
    ./ssh.nix
    ./termshark.nix
    ./tmux
    ./yazi.nix
    ./zen-browser.nix
    ./zoxide.nix
  ];

  config = mkMerge [
    (mkIf cfg.cli.enable {
      deeznuts.programs = {
        aliases.enable = mkDefault true;
        bash.enable = mkDefault true;
        bat.enable = mkDefault true;
        bc.enable = mkDefault true;
        bottom.enable = mkDefault true;
        common-utils.enable = mkDefault true;
        dblab.enable = mkDefault true;
        direnv.enable = mkDefault true;
        duf.enable = mkDefault true;
        eza.enable = mkDefault true;
        fastfetch.enable = mkDefault true;
        fd.enable = mkDefault true;
        ffmpeg.enable = mkDefault true;
        fun.enable = mkDefault true;
        fzf.enable = mkDefault true;
        gh.enable = mkDefault true;
        git.enable = mkDefault true;
        hushlogin.enable = mkDefault true;
        jq.enable = mkDefault true;
        lazydocker.enable = mkDefault true;
        lazygit.enable = mkDefault true;
        lynx.enable = mkDefault true;
        md.enable = mkDefault true;
        neovim.enable = mkDefault true;
        nmap.enable = mkDefault true;
        oh-my-posh.enable = mkDefault true;
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
