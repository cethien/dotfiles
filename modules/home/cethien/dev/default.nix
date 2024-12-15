{ ... }:

{
  imports = [
    ./nix-dev.nix

    ./make.nix
    ./just.nix
    ./quicktype.nix

    ./go.nix
    ./bun.nix

    ./ansible.nix

    ./act.nix
  ];
}
