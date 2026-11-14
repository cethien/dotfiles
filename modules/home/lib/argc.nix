{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  # i might be mad but not 200-lines-caseblock-mad
  argc = rec {
    mkArgcBashBin = {
      src,
      extraRuntimeDeps ? [],
    }: let
      name = lib.removeSuffix ".sh" (baseNameOf src);
      completionId = builtins.replaceStrings ["-"] ["_"] name;
    in
      pkgs.stdenv.mkDerivation {
        pname = name;
        version = inputs.self.lastModifiedDate or "dev";
        inherit src;
        dontUnpack = true;

        nativeBuildInputs = [pkgs-unstable.argc pkgs-unstable.makeWrapper pkgs.installShellFiles];

        installPhase = ''
          mkdir -p $out/bin
          cp $src "$out/bin/${name}"
          chmod +x "$out/bin/${name}"

          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${lib.makeBinPath ([pkgs.bash pkgs.coreutils pkgs.gnugrep pkgs.gawk pkgs.gnused pkgs-unstable.argc pkgs-unstable.gum] ++ extraRuntimeDeps)}

          mkdir -p "$out/share/argc-completions"
          ln -s "$out/bin/.${name}-wrapped" "$out/share/argc-completions/${name}.sh"

          generate_completion() {
            ${pkgs-unstable.argc}/bin/argc --argc-completions "$1" "${name}" |
              sed \
                -e "s|_argc_completer|_${completionId}_argc_completer|g" \
                -e "s|argc ${name}|${name}|g" \
                -e "s|argc --argc-compgen|${pkgs.coreutils}/bin/env ARGC_COMPLETIONS_PATH=$out/share/argc-completions ${pkgs-unstable.argc}/bin/argc --argc-compgen|"
          }

          generate_completion bash > "${name}.bash"
          generate_completion fish > "${name}.fish"
          {
            printf '#compdef %s\n\n' "${name}"
            generate_completion zsh | sed '/^compdef /,$d'
            printf '\n_%s_argc_completer "$@"\n' "${completionId}"
          } > "${name}.zsh"

          installShellCompletion --cmd "${name}" \
            --bash "${name}.bash" \
            --zsh "${name}.zsh" \
            --fish "${name}.fish"
        '';
      };

    mkArgcBashBin' = src: mkArgcBashBin {inherit src;};
  };
in {
  config.lib.deeznuts = argc;
}
