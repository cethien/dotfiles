{pkgs, ...}: let
  netz-preview = pkgs.writeShellScriptBin "netz-preview" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      networkmanager
      iproute2
      gawk
      gnugrep
      qrencode
    ])}:$PATH"

    ${builtins.readFile ./fzf-net-preview.sh}
  '';

  netz = pkgs.writeShellScriptBin "netz" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      fzf
      networkmanager
      iproute2
      tailscale
      jq
      impala
      zbar
      libnotify
      netz-preview
    ])}:$PATH"

    ${builtins.readFile ./fzf-net.sh}
  '';
in {
  home.packages = with pkgs; [
    impala
    netz
  ];

  wayland.windowManager.hyprland.extraLuaFiles = {
    "99-utils-net" =
      # lua
      ''
        Modal("netz", { binds = {
            "SUPER + N",
        } })
      '';
  };
}
