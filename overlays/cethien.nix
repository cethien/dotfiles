self: super: {
  cethien = {
    mkArgcBashBin = {
      src,
      extraRuntimeDeps ? [],
    }: let
      name = super.lib.removeSuffix ".sh" (baseNameOf src);
    in
      super.stdenv.mkDerivation {
        version = "0.1.0";
        inherit src;
        pname = name;
        dontUnpack = true;

        nativeBuildInputs = [super.argc super.makeWrapper];

        installPhase = ''
          mkdir -p $out/bin
          cp $src "$out/bin/${name}"
          chmod +x "$out/bin/${name}"

          # Wrap with argc, bash, and any extra tools like ffmpeg
          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${super.lib.makeBinPath ([super.argc super.bash] ++ extraRuntimeDeps)}

          # Generate completions for the big three
          for shell in bash zsh fish; do
            mkdir -p $out/share/''${shell}-completion/completions
            ${super.argc}/bin/argc --argc-completions $shell ${name} > \
            $out/share/''${shell}-completion/completions/${name}
          done
        '';
      };

    mkArgcBashBin' = src: self.cethien.mkArgcBashBin {inherit src;};

    mkHyprGameWindowRule = match: workspace: [
      "${match}, fullscreen on"
      "${match}, content game"
      "${match}, workspace ${toString workspace}"
    ];

    mkHyprLaunchBin = name: exec: class: let
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

    mkHyprLaunchBin' = exec: (
      self.cethien.mkHyprLaunchBin exec "kitty --class ${exec} -e ${exec}" exec
    );
  };
}
