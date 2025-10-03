self: super: {
  cethien = {
    hyprland = rec {
      writeLaunchScriptBin = name: exec: class: let
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

      writeTermLaunchScriptBin = exec:
        writeLaunchScriptBin exec "kitty --class ${exec} -e ${exec}" exec;
    };
  };
}
