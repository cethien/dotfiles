{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  argc = rec {
    mkArgcBashBin = {
      src,
      extraRuntimeDeps ? [],
    }: let
      name = lib.removeSuffix ".sh" (baseNameOf src);
    in
      pkgs.stdenv.mkDerivation {
        pname = name;
        version = inputs.self.lastModifiedDate or "dev";
        inherit src;
        dontUnpack = true;

        nativeBuildInputs = [pkgs-unstable.argc pkgs-unstable.makeWrapper];

        installPhase = ''
          mkdir -p $out/bin
          cp $src "$out/bin/${name}"
          chmod +x "$out/bin/${name}"

          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${lib.makeBinPath ([pkgs.bash pkgs-unstable.argc pkgs-unstable.gum] ++ extraRuntimeDeps)}

          for shell in bash zsh fish; do
            mkdir -p "$out/share/''${shell}-completion/completions"
            ${pkgs-unstable.argc}/bin/argc --argc-completions $shell $src ${name} > \
              "$out/share/''${shell}-completion/completions/${name}"
          done
        '';
      };

    mkArgcBashBin' = src: mkArgcBashBin {inherit src;};
  };
in {
  config.lib.deeznuts = argc;
}
