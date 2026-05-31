{
  lib,
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;

  settings = {
    version = 3;
    final_space = true;

    palette = {
      white = "#${c.base05}";
      lavender = "#${c.base0E}";
      green = "#${c.base0B}";
      skyblue = "#${c.base0C}";
      cyan = "#${c.base09}";
      violet = "#${c.base0E}";
      red = "#${c.base08}";
      yellow = "#${c.base0A}";

      session = "p:violet";
      path = "p:skyblue";
      git = "p:lavender";
      shell = "p:green";
      root = "p:red";
      text = "p:white";
      exitcode = "p:red";
    };

    blocks = [
      {
        alignment = "left";
        type = "prompt";
        segments = [
          {
            type = "session";
            style = "plain";
            foreground = "p:session";
            template = "{{ if .SSHSession }}ﮩ {{ end }}{{ .UserName }}@{{ .HostName }} ";
          }
          {
            type = "path";
            style = "plain";
            foreground = "p:path";
            template = "{{ .Path }}";
            properties = {
              style = "full";
              home_icon = "~";
            };
          }
          {
            type = "git";
            style = "plain";
            foreground = "p:git";
            template = " {{ .HEAD }} ";
            properties = {
              branch_icon = " ";
              cherry_pick_icon = " ";
              commit_icon = " ";
              merge_icon = " ";
              no_commits_icon = " ";
              rebase_icon = " ";
              revert_icon = " ";
              tag_icon = " ";
              fetch_status = true;
              fetch_stash_count = true;
              fetch_upstream_icon = true;
            };
            foreground_templates = [
              "{{ if or (.Working.Changed) (.Staging.Changed) }}#${c.base08}{{ end }}"
              "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#${c.base08}{{ end }}"
              "{{ if gt .Ahead 0 }}#${c.base0E}{{ end }}"
              "{{ if gt .Behind 0 }}#${c.base0E}{{ end }}"
            ];
          }
        ];
      }
      {
        alignment = "left";
        newline = true;
        type = "prompt";
        segments = [
          {
            type = "shell";
            style = "plain";
            foreground = "p:shell";
            template = "{{ .Name }} ";
          }
          {
            type = "root";
            style = "plain";
            foreground = "p:root";
            template = "!";
          }
          {
            type = "text";
            style = "plain";
            foreground = "p:text";
            template = "";
          }
        ];
      }
    ];
  };
in {
  config = {
    programs.oh-my-posh = {
      inherit settings;
    };
  };
}
