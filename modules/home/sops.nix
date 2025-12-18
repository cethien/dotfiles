{
  config,
  sops-nix,
  ...
}: {
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./users/cethien/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
