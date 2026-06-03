{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkMerge;
  cfg = config.programs.git;
in {
  config = {
    programs.git.settings = {
      user = {
        name = mkDefault "cethien";
        email = mkDefault "borislaw.sotnikow@gmx.de";
      };

      alias = {
        ignore = "!gi() { ${pkgs.git-ignore}/bin/git-ignore -w $@;}; gi";
        license = "!gl() { ${pkgs.license-go}/bin/license -o LICENSE $@ ;}; gl";
      };
      core = {
        eol = "lf";
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autostash = true;
      push.autoSetupRemote = true;
      advice.addIgnoredFile = false;

      url = {
        "git@github.com:".insteadOf = "gh:";
        "git@gitlab.com:".insteadOf = "gl:";
        "git@codeberg.org:".insteadOf = "cb:";
        "git@bitbucket.org:".insteadOf = "bb:";
      };
    };

    programs.diff-so-fancy.enable = true;
    programs.diff-so-fancy.enableGitIntegration = true;
  };
}
