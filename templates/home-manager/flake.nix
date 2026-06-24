{
  description = "home-manager stable";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # TODO: changeme
    username = "<changeme>";
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
        {
          home.username = "${username}";
          home.homeDirectory = "/home/${username}";
          home.stateVersion = "26.05";

          programs.home-manager.enable = true;
          services.home-manager.autoExpire = {
            enable = true;
            frequency = "weekly";
          };
          news.display = "silent";

          nix = {
            package = pkgs.nix;
            settings = {
              experimental-features = ["nix-command" "flakes"];
              warn-dirty = false;
              max-jobs = "auto";
            };
          };
        }
      ];
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
