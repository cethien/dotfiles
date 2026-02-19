{
  config,
  sops-nix,
  ...
}: {
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
