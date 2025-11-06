{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkOption types mkMerge;
in {
  options.programs.git.urlExtra = mkOption {
    type = types.attrsOf (types.attrsOf types.str);
    default = {};
    description = ''
      Extra Git URL rewrites to merge with the default GitHub/GitLab mappings.
      Example:
        {
          "ssh://git@bitbucket.org".insteadOf = "https://bitbucket.org";
        }
    '';
  };

  config = {
    programs.git.settings = {
      user = {
        name = mkDefault "cethien";
        email = mkDefault "borislaw.sotnikow@gmx.de";
      };

      alias = {
        ignore = "!gi() { ${pkgs.git-ignore}/bin/git-ignore $@ ;}; gi";
        license = "!gl() { ${pkgs.license-go}/bin/license $@ ;}; gl";
        stat = "!gscc() {${pkgs.scc}/bin/scc $@ ;}; gscc";
      };
      core = {
        eol = "lf";
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      advice.addIgnoredFile = false;

      url = mkMerge [
        {
          "ssh://git@github.com".insteadOf = "https://github.com";
          "git@github.com:".insteadOf = "gh:";

          "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
          "git@gitlab.com:".insteadOf = "gl:";
        }
        config.programs.git.urlExtra
      ];
    };

    programs.kitty.enableGitIntegration = true;
    programs.lazygit.enable = true;
    programs.diff-so-fancy.enable = true;
    programs.diff-so-fancy.enableGitIntegration = true;

    programs.tmux.resurrectPluginProcesses = ["lazygit"];
    home.shellAliases.lzg = "lazygit";
  };
}
