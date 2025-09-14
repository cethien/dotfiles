{lib, ...}:
with lib; {
  imports = [
    ./cethien.nix
  ];

  options.deeznuts.users = mkOption {
    type = types.listOf types.str;
    default = [];
    description = "list of users to activate";
  };
}
