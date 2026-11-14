{pkgs}: let
  runtimeDeps = with pkgs; [
    bash
    age
    ssh-to-age
    gum
    argc
    nvd
  ];
in
  pkgs.stdenv.mkDerivation {
    pname = "doot";
    version = "0.1.0";

    src = ./doot.sh;
    dontUnpack = true;

    nativeBuildInputs = with pkgs; [
      argc
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 $src $out/bin/doot

      runHook postInstall
    '';

    postInstall = ''
      wrapProgram $out/bin/doot \
        --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}

      mkdir -p $out/share/bash-completion/completions
      argc --argc-completions bash doot |
        sed \
          -e "s|_argc_completer|_doot_argc_completer|g" \
          -e "s|argc doot|doot|g" \
          -e "s|argc --argc-compgen|${pkgs.argc}/bin/argc --argc-compgen|" \
          -e "s|bash \"\"|bash $out/bin/.doot-wrapped|" \
        > $out/share/bash-completion/completions/doot
    '';
  }
