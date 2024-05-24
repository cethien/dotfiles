{ config, pkgs, lib, ... }:

{
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = "23.05"; # dont change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    nil

    socat

    procs
    bat
    eza
    fd
    ripgrep
    curl
    zip
    unzip
    wget
    fzf
    duf

    oh-my-posh

    gnumake
    wgo
    quicktype

    act

    gopls
    go-tools
    delve
    goreleaser

    hugo
    nodejs

    bun
    jdk8
    lua

    ansible
    ansible-lint
    sshpass

    gimp
    inkscape
    ocenaudio
  ];

  home.activation.checkEnvVars = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -z "$WSLENV" ] || [ -z "$USERPROFILE" ] || [ -z "$POSH_THEMES_PATH" ]; then
        echo "WSLENV / needed variables from WSLENV could not be loaded. Exiting"
        exit 1
      fi
    '';

  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  home.shellAliases = {
      sudo = "sudo ";
      apt = "nala";
      ps = "proc";
      duf = "df";
      cd = "z";
      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -a --icons --group-directories-first --git";
      tree = "eza -T --icons";
      grep = "rg";
      cat = "bat -p";
      find = "fd";
      vi = "nvim";
      vim = "nvim";

      # git
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gaa = "git add .";
      gaf = "git add -f";

      gc = "git commit";
      gcm = "git commit -m";
      gcam = "git commit -am";

      gco = "git checkout";
      gcob = "git checkout -b";

      gcl = "git clone";
      gclb = "git clone --bare";

      gf = "git fetch";

      gpl = "git pull";

      gps = "git push";

      glg = "git log --graph --oneline --decorate";

      gwa = "git worktree add";
      gwl = "git worktree list";
      gwt = "git worktree prune";

      gss = "git stash";
      gsp = "git stash pop";

      # commands
      update = "source $HOME/scripts/update.sh";
      reload = "(cd $HOME && source .profile) && clear";
      init = "source $HOME/scripts/init.sh";
      sync = "(cd $HOME && git pull)";
      rebuild = "(cd $HOME && home-manager switch)";
      clean = "nix-store --gc";

      devenv-up = "docker compose -f $HOME/compose-devenv.yml -p dev-env up --remove-orphans -d";
      devenv-down = "docker compose -f $HOME/compose-devenv.yml -p dev-env down";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    profileExtra = ''
      if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
        source "$HOME"/.nix-profile/etc/profile.d/nix.sh;
      fi

      if [ -e /usr/local/bin/ssh-agent-pipe ]; then
        source /usr/local/bin/ssh-agent-pipe;
      fi
    '';

    initExtra = ''
      export PATH=$GOBIN:$PATH
      eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/custom/negligible.omp.json)"
    '';
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    forwardAgent = true;
  };

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;

    userName = "cethien";
    aliases.ignore = "!gi() { curl -fsSL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
    extraConfig = {
      core = {
        eol = "lf";
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
      advice = {
        addIgnoredFile = false;
      };
    };
  };

  programs.zoxide.enable = true;

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number
    '';
  };

  programs.direnv = {
    enable = true;
    config.whitelist.exact = [ "~/" ];
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        rcp = "repo create --private";
        rc = "repo create";
      };
    };
  };

  programs.go = {
    enable = true;

    goPath = "go";
    goBin = "go/bin";
  };
}
