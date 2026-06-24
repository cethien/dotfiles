{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "home-manager-dev-shell";

  buildInputs = with pkgs; [
    alejandra
    stylua

    nixd
    lua-language-server
  ];

  shellHook = ''
    echo "⚡ Home Manager Dev Shell loaded!"
  '';
}
