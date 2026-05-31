{
  lib,
  config,
  pkgs,
  ...
}: let
  deeznuts = {
    mkMimeApps = categories: let
      mkHandlers = {
        types,
        desktop,
      }:
        builtins.listToAttrs (map (t: {
            name = t;
            value = [desktop];
          })
          types);
    in
      builtins.foldl' (
        acc: cat:
          acc // mkHandlers cat
      ) {} (builtins.attrValues categories);

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

          # Wrap with argc, bash, and any extra tools like ffmpeg
          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${lib.makeBinPath ([pkgs.argc pkgs.bash] ++ extraRuntimeDeps)}

          # Generate completions for the big three
          for shell in bash zsh fish; do
            mkdir -p $out/share/''${shell}-completion/completions
            ${pkgs.argc}/bin/argc --argc-completions $shell ${name} > \
            $out/share/''${shell}-completion/completions/${name}
          done
        '';
      };

    mkArgcBashBin' = src: deeznuts.mkArgcBashBin {inherit src;};

    mkHyprGameWindowRules = matches: gamingWorkspace:
      if gamingWorkspace == null
      then []
      else
        builtins.concatMap (match: [
          "${match}, fullscreen on, content game, workspace ${toString gamingWorkspace}"
        ])
        matches;
  };
in {
  config.lib.deeznuts = deeznuts;
}
