{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.deeznuts) mkArgcBashBin mkArgcBashBin';
  cfg = config.programs.utils;

  newnote = mkArgcBashBin {
    src = ./newnote.sh;
    extraRuntimeDeps = [pkgs.gum];
  };

  exec = "${newnote}/bin/newnote";
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      newnote
      (mkArgcBashBin' ./init.sh)
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];

    xdg.desktopEntries.create-note = {
      name = "newnote";
      inherit exec;
      terminal = true;
      icon = "text-editor";
      categories = ["Utility"];
    };

    programs.tmux = {
      launcher.entries = let
        nix-shell-wrapper = pkgs.writeShellScriptBin "nix-shell-wrapper" ''
          input=$(${pkgs.gum}/bin/gum input --placeholder="e.g. ripgrep fd  OR  cowsay")

          [ -z "$input" ] && exit 0

          args=""
          for pkg in $input; do
            if [[ "$pkg" == *#* ]]; then
              args="$args $pkg"
            else
              args="$args nixpkgs#$pkg"
            fi
          done

          exec nix shell $args
        '';
        icon = "󱄅";
      in [
        {
          inherit icon;
          name = "nix run";
          exec = ", $(${pkgs.gum}/bin/gum input --placeholder='e.g. cowsay hello')";
          hold = true;
        }
        {
          inherit icon;
          name = "nix shell";
          exec = "${nix-shell-wrapper}/bin/nix-shell-wrapper";
        }
      ];

      keybindings = [
        {
          key = "n";
          action = "new-window -n newnote ${exec}";
        }
      ];
    };
  };
}
