{
  description = "cethien's dotfiles";

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.nur.overlays.default ];
      };

      stateVersion = "25.05";
      defaultUser = "cethien";
    in
    {
      homeConfigurations = {
        "cethien@lpt-sotnikow" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homes/cethien_WSL
            ./modules/shared/catppuccin
            inputs.catppuccin.homeManagerModules.catppuccin

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

        "cethien@tower-of-power" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homes/cethien_tower-of-power
            ./modules/shared/catppuccin
            inputs.catppuccin.homeManagerModules.catppuccin
            inputs.sops-nix.homeManagerModules.sops
            inputs.plasma-manager.homeManagerModules.plasma-manager
            inputs.nur.modules.homeManager.default
            inputs.spicetify-nix.homeManagerModules.default

            {
              home.stateVersion = stateVersion;
              home.username = defaultUser;
              home.homeDirectory = "/home/${defaultUser}";
            }
          ];

          extraSpecialArgs = {
            inherit inputs system;
          };
        };
      };
    }
    // {
      nixosConfigurations = {
        "tower-of-power" = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./systems/tower-of-power
            ./modules/shared/catppuccin
            inputs.sops-nix.nixosModules.sops
            inputs.catppuccin.nixosModules.catppuccin

            {
              system.stateVersion = stateVersion;
              networking.hostName = "tower-of-power";
            }
          ];

          specialArgs = {
            inherit inputs;
          };
        };
      };
    }
    // {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git

          nil
          nixpkgs-fmt
          sops
          lua

          just
        ];

        shellHook = ''
          if [ ! -f .env ]; then
            cp .env.TEMPLATE .env
            $EDITOR .env
          fi
        '';
      };
    };


  inputs = {
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
