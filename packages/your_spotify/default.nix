{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  makeWrapper,
  callPackage,
}: let
  rev = "fa039573413bd85f16e085cdc219b751a98510bf";
  version = "1.20.1-fork.8";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "your_spotify_server";
  inherit version;

  src = fetchFromGitHub {
    owner = "TheTastyHanuta";
    repo = "your_spotify";
    inherit rev;
    hash = "sha256-Guzrekkm9Kg5aXXJ5XTB66nTo012J+vliP//NwkzQBw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-+D6sbFfb16J8pUuji+pfCUansB2ufsMq6+ioQdXMcq0=";
  };

  nativeBuildInputs = [
    makeWrapper
    pnpmConfigHook
    pnpm_11
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    pushd ./apps/server/
    pnpm run build
    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/your_spotify
    cp -r apps/server/build $out/share/your_spotify/
    mkdir -p $out/bin
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_migrate" \
      --add-flags "$out/share/your_spotify/build/index.js" --add-flags "--migrate"
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_server" \
      --add-flags "$out/share/your_spotify/build/index.js"

    runHook postInstall
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit
        (finalAttrs)
        src
        version
        pnpmDeps
        meta
        ;
    };
  };

  meta = {
    homepage = "https://github.com/TheTastyHanuta/your_spotify";
    description = "Self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about it (actively maintained fork)";
    license = lib.licenses.gpl3Only;
    mainProgram = "your_spotify_server";
  };
})
