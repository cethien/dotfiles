{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
in {
  config = mkIf config.programs.git.enable {
    programs.git = {
      userName = mkDefault "cethien";
      userEmail = mkDefault "borislaw.sotnikow@gmx.de";
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
    programs.lazygit.enable = true;
    programs.tmux.resurrectPluginProcesses = ["lazygit"];

    home.packages = with pkgs; [
      scc
    ];
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
