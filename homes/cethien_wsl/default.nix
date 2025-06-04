{
  pkgs,
  home-manager,
  stateVersion,
  user ? "cethien",
  sops-nix,
  stylix,
  nvf,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    inherit sops-nix stylix nvf;
  };
  modules = [
    {
      home.stateVersion = stateVersion;
      home.username = user;
      home.homeDirectory = "/home/${user}";

      deeznuts.programs = {
        cli.enable = true;
        bash.sourceNixProfile = true;
      };
    }
  ];
}
