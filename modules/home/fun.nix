{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.programs.fun;
in {
  options.programs.fun = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrule = ["match:class ^(cmatrix)$, fullscreen on"];
      bind = [
        "SUPER SHIFT, Z, exec, ${
          (pkgs.cethien.mkHyprLaunchBin' "cmatrix").bin
        }"
      ];
    };

    home.packages = let
      reasonsJson = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/hotheadhacker/no-as-a-service/refs/heads/main/reasons.json";
        sha256 = "sha256:00a16hrbc99i3fcrihg6xf61fip6kc9dbd0brsvrd5kw0zwbjdgm";
      };
      suffContent = builtins.readFile ./suff.txt;
    in
      with pkgs; [
        cmatrix
        asciiquarium-transparent
        hackertyper
        ttysvr
        cowsay
        figlet
        dotacat

        (pkgs.writeShellScriptBin "nope" ''
          ${pkgs.jq}/bin/jq -r '.[]' ${reasonsJson} | shuf -n 1
        '')
        (pkgs.writeShellScriptBin "suff" ''
          cat << 'EOF' | ${pkgs.coreutils}/bin/shuf -n 1
          ${suffContent}
          EOF
        '')
      ];

    home.shellAliases = {
      lolcat = "dotacat";
      matrix = "cmatrix";
      pipes = "${pkgs.pipes-rs}/bin/pipes-rs";
      sl = "${pkgs.sl}/bin/sl | ${pkgs.lolcat}/bin/lolcat && clear";
      fortune = ''
        ${pkgs.fortune}/bin/fortune cookie | cowthink -e "$(printf "oo\n**\n__\n^^\n$$\n@@\n==\nxx\n..\n" | shuf | head -n 1)" -C | dotacat
      '';
    };
  };
}
