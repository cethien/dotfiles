{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.lazygit;
in {
  config = mkIf cfg.enable {
    programs.lazygit = {
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
