{
  lib,
  config,
  pkgs,
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
        version = "0.1.0";
        inherit src;
        dontUnpack = true;

        nativeBuildInputs = [pkgs.argc pkgs.makeWrapper];

        installPhase = ''
          mkdir -p $out/bin
          cp $src "$out/bin/${name}"
          chmod +x "$out/bin/${name}"

          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${lib.makeBinPath ([pkgs.argc pkgs.bash pkgs.gum] ++ extraRuntimeDeps)}

          for shell in bash zsh fish; do
            mkdir -p "$out/share/''${shell}-completion/completions"
            ${pkgs.argc}/bin/argc --argc-completions $shell $src ${name} > \
              "$out/share/''${shell}-completion/completions/${name}"
          done
        '';
      };

    mkArgcBashBin' = src: mkArgcBashBin {inherit src;};
  };
in {
  config.lib.deeznuts = argc;
}
