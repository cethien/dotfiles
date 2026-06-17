{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  hl = config.wayland.windowManager.hyprland.enable;
  mg = config.programs.steam.enable || config.programs.heroic.enable || config.programs.prismlauncher.enable;

  inherit (config.lib.deeznuts) mkMimeApps;
  browser = config.deeznuts.defaultBrowser;
in {
  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  config = {
    services = {
      syncthing.enable = mkDefault true;
      restic.enable = mkDefault true;
    };

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      pay-respects.enable = true;

      bash.enable = true;
      oh-my-posh.enable = true;
      tmux.enable = true;
      ssh.enable = true;
      yazi.enable = true;
      utils.enable = mkDefault true;
      utils-remote.enable = mkDefault true;
      utils-net.enable = mkDefault true;
      utils-fun.enable = mkDefault true;

      pandoc.enable = true;
      jq.enable = true;
      zoxide.enable = true;
      ripgrep.enable = true;
      tealdeer.enable = true;
      fzf.enable = true;
      fd.enable = true;
      eza.enable = true;
      bat.enable = true;
      fastfetch.enable = true;
      bottom.enable = mkDefault true;
      utils-qol.enable = mkDefault true;
      cava.enable = mkDefault true;

      git.enable = mkDefault true;
      lazygit.enable = config.programs.git.enable;
      direnv.enable = true;
      direnv = {
        silent = true;
        nix-direnv.enable = true;
        config.global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };
      neovim.enable = true;
      lazysql.enable = true;
      gh.enable = mkDefault true;
      gh.settings.git_protocol = "ssh";
      gh-dash.enable = true;
      tmux.resurrectPluginProcesses = ["gh-dash"];

      spotify-player.enable = mkDefault true;
      wiremix.enable = mkDefault hl;
      keepassxc.enable = mkDefault hl;
      keepassxc.hyprlandAutostart = mkDefault true;
      zen-browser.enable = mkDefault hl;
      zen-browser.isDefault = mkDefault config.programs.zen-browser.enable;
      aria2.enable = mkDefault config.programs.zen-browser.enable;
      localsend.enable = mkDefault hl;

      mangohud.enable = mkDefault mg;
    };

    userfonts.enable = mkDefault (
      config.programs.libreoffice.enable
      || config.programs.apps-creative.enable
    );

    xdg.enable = true;
    xdg.mimeApps.enable = true;

    xdg.mimeApps.defaultApplications = mkIf (browser != null) (
      mkMimeApps {
        browsers = {
          desktop = browser;
          types = [
            "x-scheme-handler/about"
            "x-scheme-handler/chrome"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/unknown"
          ];
        };
      }
    );

    # fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      curl
      wget
      gnutar
      gzip
      bzip2
      bzip3
      xz
      zip
      unzip
      rar
      p7zip
      file
      yq-go

      parted
      openssl

      ffmpeg
    ];

    home.file."${config.home.homeDirectory}/.hushlogin".text = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

    sops.age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];

    stylix.enable = true;

    programs.home-manager.enable = true;
    services.home-manager.autoExpire = {
      enable = true;
      frequency = "weekly";
    };
    news.display = "silent";
  };
}
