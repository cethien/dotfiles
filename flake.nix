{
  description = "cethien's dotfiles";

  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [inputs.nur.overlays.default];
    };

    stateVersion = "25.05";
    defaultUser = "cethien";
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        just
        sops
      ];
    };

    packages.${system}.setup-age = import ./scripts/setup-age.nix {inherit pkgs;};

    homeConfigurations."cethien@wsl" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./homes/cethien_WSL
        {
          home.stateVersion = stateVersion;
          home.username = defaultUser;
          home.homeDirectory = "/home/${defaultUser}";
        }
      ];

      extraSpecialArgs = {
        inherit inputs;
      };
    };

    nixosConfigurations."tower-of-power" = import ./systems/tower-of-power {inherit pkgs inputs stateVersion;};
    homeConfigurations."cethien@tower-of-power" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./homes/cethien_tower-of-power

        inputs.nur.modules.homeManager.default
        {
          home.stateVersion = stateVersion;
          home.username = defaultUser;
          home.homeDirectory = "/home/${defaultUser}";
        }
      ];

      extraSpecialArgs = {
        inherit inputs;
      };
    };

    nixosConfigurations."hp-430-g7" = import ./systems/hp-430-g7 {inherit pkgs inputs stateVersion;};
    homeConfigurations."cethien@hp-430-g7" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./homes/cethien_hp-430-g7
        inputs.nur.modules.homeManager.default
        {
          home.stateVersion = stateVersion;
          home.username = defaultUser;
          home.homeDirectory = "/home/${defaultUser}";
        }
      ];

      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
