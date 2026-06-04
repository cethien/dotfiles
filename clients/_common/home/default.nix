{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkDefault;

  hl = config.wayland.windowManager.hyprland.enable;
  mg = config.programs.steam.enable || config.programs.heroic.enable || config.programs.prismlauncher.enable;
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
      nvf.enable = true;
      lazysql.enable = true;
      gh.enable = mkDefault true;
      gh.settings.git_protocol = "ssh";
      gh-dash.enable = true;
      tmux.resurrectPluginProcesses = ["gh-dash"];

      spotify-player.enable = mkDefault true;
      wiremix.enable = mkDefault hl;
      kitty.enable = mkDefault hl;
      keepassxc.enable = mkDefault (hl && config.services.syncthing.enable);
      zen-browser.enable = mkDefault hl;
      browser.default = config.programs.zen-browser.package;
      aria2.enable = mkDefault config.programs.zen-browser.enable;

      mpv.enable = mkDefault hl;
      imv.enable = mkDefault hl;
      zathura.enable = mkDefault hl;
      fileroller.enable = mkDefault hl;

      mangohud.enable = mkDefault mg;
    };

    userfonts.enable = mkDefault (
      config.programs.libreoffice.enable
      || config.programs.apps-creative.enable
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

    xdg.mimeApps.enable = true;
    programs.home-manager.enable = true;
    services.home-manager.autoExpire = {
      enable = true;
      frequency = "weekly";
    };
    news.display = "silent";
  };
}
