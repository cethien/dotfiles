{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
  cfg = config.programs.git;
in {
  config = {
    programs.git.settings = {
      user = {
        name = mkDefault "cethien";
        email = mkDefault "borislaw.sotnikow@gmx.de";
      };

      alias = {
        ignore = "!${pkgs.git-ignore}/bin/git-ignore -w";
        license = "!${pkgs.license-go}/bin/license -o LICENSE";
        view-statistics = "!${pkgs.scc}/bin/scc --no-cocomo --no-size";
      };
      core = {
        eol = "lf";
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autostash = true;
      fetch.prune = true;
      push.autoSetupRemote = true;
      advice.addIgnoredFile = false;
    };

    programs.diff-so-fancy.enable = true;
    programs.diff-so-fancy.enableGitIntegration = true;
  };
}
