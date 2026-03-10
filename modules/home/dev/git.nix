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

    programs.kitty.enableGitIntegration = config.programs.kitty.enable;
    programs.diff-so-fancy.enable = true;
    programs.diff-so-fancy.enableGitIntegration = true;

    programs.lazygit = {
      enable = config.programs.git.enable;
      shellWrapperName = "lzg";
      settings = {
        update.method = "never";
        disableStartupPopups = true;
        notARepository = "quit";
        promptToReturnFromSubprocess = false;
        os.openDirInEditor = "$EDITOR";

        customCommands = [
          {
            key = "l";
            description = "Add LICENSE file";
            context = "files";
            command = "${pkgs.license-go}/bin/license -o LICENSE {{.Form.License}}";
            prompts = [
              {
                type = "menuFromCommand";
                title = "Select License";
                key = "License";
                command = "${pkgs.license-go}/bin/license -list";
                filter = "^(?P<id>\\S+)\\s+(?P<desc>.*)";
                valueFormat = "{{ .id }}";
                labelFormat = "{{ .id | yellow }} {{ .desc | cyan }}";
              }
            ];
          }
          {
            key = "<f3>";
            description = "open gh-dash";
            command = "${pkgs.gh-dash}/bin/gh-dash";
            context = "global";
            output = "terminal";
          }

          {
            key = "<f1>";
            description = "Show code statistics";
            command = "${pkgs.scc}/bin/scc --no-cocomo --no-size";
            context = "global";
            output = "popup";
            outputTitle = "Stats";
          }
        ];
      };
    };
    programs.tmux.resurrectPluginProcesses = ["lazygit"];
  };
}
