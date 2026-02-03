{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "doot";
  version = "0.1.0";

  src = ./doot.sh;
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [
    argc
  ];

  runtimeDeps = with pkgs; [
    bash
    yq-go
    openssh

    argc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/doot
    chmod +x $out/bin/doot

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    argc --argc-completions bash doot \
      > $out/share/bash-completion/completions/doot
  '';
}
