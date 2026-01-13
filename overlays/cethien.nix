self: super: {
  cethien = {
    mkHyprGameWindowRule = match: workspace: [
      "${match}, fullscreen on"
      "${match}, content game"
      "${match}, workspace ${toString workspace}"
    ];

    writeHyprlandLaunchScriptBin = name: exec: class: let
      drv =
        super.writeShellScriptBin "hypr_${name}"
        ''
          hyprctl clients | grep ${class} &&
          hyprctl dispatch focuswindow class:${class} ||
          nohup ${exec} >/dev/null 2>&1 &
        '';
    in {
      inherit drv;
      name = drv.name;
      out = drv.out;
      bin = "${drv.out}/bin/${drv.name}";
    };

    writeHyprlandTermLaunchScriptBin = exec: (self.cethien.writeHyprlandLaunchScriptBin exec "kitty --class ${exec} -e ${exec}" exec);
  };
}
