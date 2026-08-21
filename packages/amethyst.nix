{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  python3,
  libloot,
}: let
  # Alle Python-Abhängigkeiten in eine Env verpacken
  pythonEnv = python3.withPackages (ps:
    with ps; [
      pyside6
      pygobject3
      pillow
      certifi
      requests
      keyring
      secretstorage
      cryptography
      jeepney
      msgpack
      lz4
      py7zr
      zstandard
      rarfile
      bsdiff4
      libloot
    ]);
in
  stdenv.mkDerivation rec {
    pname = "amethyst-mod-manager";
    version = "2.2.0";

    src = fetchFromGitHub {
      owner = "ChrisDKN";
      repo = "Amethyst-Mod-Manager";
      tag = "v${version}";
      sha256 = "sha256-1ZahPn/eBTXWV3GR17PzhzVnp+xx2QDJQkThjzmcpDY=";
    };

    postPatch = ''
      # Den Import-Fehler im LOOT-Sorter flicken
      sed -i 's/import LOOT.loot as loot/import loot/' src/LOOT/loot_sorter.py

      # Das Version-Skript für Meson vorbereiten
      chmod +x src/version.py
      patchShebangs src/version.py
    '';

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      wrapGAppsHook4
      pythonEnv
    ];

    gappsWrapperArgs = [
      "--set GDK_BACKEND wayland"
    ];

    # Meson haut die Python-Sourcen flach nach site-packages.
    # Wir patchen den Launcher so, dass er direkt die gepackte Python-Env nutzt.
    postInstall = ''
      mkdir -p $out/bin

      # Launch-Script für GUI überschreiben
      cat <<EOF > $out/bin/amethyst-mod-manager
      #!/bin/sh
      export PYTHONPATH="$out/${python3.sitePackages}:\$PYTHONPATH"
      exec ${pythonEnv}/bin/python3 -m run_qt "\$@"
      EOF

      # Launch-Script für CLI überschreiben
      cat <<EOF > $out/bin/amethyst-mod-manager-cli
      #!/bin/sh
      export PYTHONPATH="$out/${python3.sitePackages}:\$PYTHONPATH"
      exec ${pythonEnv}/bin/python3 -m cli "\$@"
      EOF

      chmod +x $out/bin/amethyst-mod-manager $out/bin/amethyst-mod-manager-cli
    '';

    meta = with lib; {
      description = "A Linux native mod manager for a variety of games";
      homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
    };
  }
