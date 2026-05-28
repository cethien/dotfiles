{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  import = [
    ../../modules/host
  ];

  config = {
    deployrs.enable = true;
    programs.command-not-found.enable = true;

    environment.systemPackages = with pkgs; [
      git
      neovim

      htop
      sysstat

      gptfdisk
      parted
      xfsprogs
      duf
      iotop
      ncdu

      fzf
      sysz

      curl
      nettools
      iproute2
      traceroute
      mtr
      dig
    ];

    programs.tmux.enable = true;
    programs.tmux = {
      keyMode = "vi";
      newSession = true;
      clock24 = true;
      aggressiveResize = true;
      plugins = with pkgs.tmuxPlugins; [
        resurrect
        continuum
      ];

      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '15' # Intervall in Minuten

        set -g mouse on

        # 1. Left panel: Conditional User@Hostname
        set -g status-left-length 30
        set -g status-left "#[fg=red]#(whoami)@#h #[default]"

        # 2. Status Bar: "index name" format + Transparency
        set -g status-style bg=default
        set -g window-status-format "#[fg=white]#I #W "
        set -g window-status-current-format "#[fg=blue,bold]#I #W "

        # 3. Pane Colors (Text white, focused blue)
        set -g window-style 'bg=default'
        set -g window-active-style 'bg=default'
        set -g pane-border-style fg=white
        set -g pane-active-border-style fg=blue

        # 4. Bottom Border for Panes (The "Line" above the status bar)
        set-option -g pane-border-status bottom
        set-option -g pane-border-format ""  # Keep it a clean line

        # Optional: Add a small gap by using a 2-line status bar
        # (supported in tmux 2.9+)
        # set -g status 2
        # set -g 'status-format[0]' ""
        # set -g 'status-format[1]' "#[fg=red]#(whoami)@#h #[default].
      '';
    };

    services.openssh.enable = mkDefault true;
    services.openssh.settings = {
      LogLevel = mkDefault "VERBOSE";
      PermitRootLogin = mkDefault "no";
      UsePAM = mkDefault false;
      PasswordAuthentication = mkDefault false;
      X11Forwarding = false;
      AllowTcpForwarding = "no";
      AllowAgentForwarding = "no";
      ClientAliveInterval = mkDefault "600";
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "de-latin1-nodeadkeys";

    networking.networkmanager.enable = true;

    users.users.cethien.enable = true;

    documentation.enable = false;
    documentation.nixos.enable = false;
    nix = {
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      settings = {
        extra-experimental-features = "nix-command flakes";
        warn-dirty = false;
        trusted-users = ["@wheel"];
        allowed-users = ["@wheel"];
      };
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 2048;
      }
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = mkDefault true;
    };
  };
}
