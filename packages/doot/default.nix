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
      argc --argc-completions bash doot \
        > $out/share/bash-completion/completions/doot
    '';
  }
