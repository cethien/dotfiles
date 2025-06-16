{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) str;
  cfg = config.deeznuts.programs.dev.git;
in {
  options.deeznuts.programs.dev.git = {
    userName = mkOption {
      type = str;
      default = "cethien";
      description = "The user name to use for git commits";
    };
    userEmail = mkOption {
      type = str;
      default = "borislaw.sotnikow@gmx.de";
      description = "The user email to use for git commits";
    };
  };

  config = mkIf config.programs.git.enable {
    home.packages = with pkgs; [
      scc
    ];

    programs.lazygit.enable = true;

    programs.git = {
      inherit (cfg) userName userEmail;
      aliases = {
        ignore = "!gi() { ${pkgs.git-ignore}/bin/git-ignore $@ ;}; gi";
        license = "!gl() { ${pkgs.license-go}/bin/license $@ ;}; gl";
      };

      extraConfig = {
        core = {
          eol = "lf";
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        advice.addIgnoredFile = false;
        url = {
          "ssh://git@github.com".insteadOf = "https://github.com";
          "git@github.com:".insteadOf = "gh:";
          "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
          "git@gitlab.com:".insteadOf = "gl:";
        };
      };

      diff-so-fancy.enable = true;
    };

    home.shellAliases = {
      lzg = "lazygit";

      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gaa = "git add .";

      gc = "git commit -m";
      gca = "git commit -am";

      gco = "git checkout";
      gcob = "git checkout -b";

      gcl = "git clone";
      gclb = "git clone --bare";

      gf = "git fetch";

      gpl = "git pull";

      gps = "git push";

      gw = "git worktree";
      gwa = "git worktree add";
      gwrm = "git worktree remove";
      gwl = "git worktree list";
      gwt = "git worktree prune";

      gss = "git stash";
      gsp = "git stash pop";
    };
  };
}
