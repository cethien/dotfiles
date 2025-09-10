{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.qol;
in {
  imports = [
    ./bottom.nix
    ./bash-options.nix
    ./yazi.nix
  ];

  options.deeznuts.programs.qol = {
    enable = mkEnableOption "QoL utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      procs
      duf
      gdu

      glow
      mdcat

      epr
      bk

      termshot

      (writeShellScriptBin "update" (builtins.readFile ./scripts/update.sh))
      (writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./scripts/cleanup.sh))
      (writeShellScriptBin "init" (builtins.readFile ./scripts/init.sh))
    ];

    programs = {
      yazi.enable = true;

      zoxide.enable = true;
      zoxide.options = ["--cmd cd"];
      ripgrep.enable = true;
      ripgrep.arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
      fzf.enable = true;
      fzf = {
        defaultCommand = "fd --type f";
        fileWidgetCommand = "fd --type f";
        changeDirWidgetCommand = "fd --type d";
      };
      fd.enable = true;
      eza.enable = true;
      bat.enable = true;

      bottom.enable = true;

      oh-my-posh.enable = true;
      oh-my-posh.settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh/themes/cethien.omp.json)
      );
      bash.blesh.enable =
        true;
      bash.enable = true;
    };

    home.shellAliases = {
      cp = "cp -i";

      cdc = "cd ~/.config";
      cdd = "cd ~/Downloads";

      mkdir = "mkdir -p";

      grep = "rg";
      ps = "procs";

      find = "fd";
      findf = "fd --type f";
      findd = "fd --type d";

      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -1a --icons --group-directories-first --git";
      tree = "eza -T --icons";

      df = "duf";
      du = "duf";

      cat = "bat -p";

      reload = "source ~/.bashrc && clear";
      rebuild-os = "rebuild -n";
    };

    home.file."${config.home.homeDirectory}/.hushlogin".text = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

    programs.hyprpanel.settings.bar.workspaces.applicationIconMap.yazi = "󰝰";
    # xdg.mimeApps.defaultApplications."inode/directory" = ["yazi.desktop"];
    # wayland.windowManager.hyprland.settings = {
    #   bind = [
    #     "SUPER, e, exec, $terminal --class yazi -e yazi"
    #   ];
    # };
  };
}
