{ ... }:

{
  programs.git = {
    enable = true;
    userName = "cethien";
    userEmail = "borislaw.sotnikow@gmx.de";

    aliases = {
      ignore = "!gi() { curl -fsSL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
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
        "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
      };
    };

    diff-so-fancy.enable = true;
  };

  home.shellAliases = {
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
  };
}
