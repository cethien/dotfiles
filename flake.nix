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
        "cethien@wsl" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homes/cethien_WSL

            inputs.sops-nix.homeManagerModules.sops
            ./shared/sops

            inputs.stylix.homeManagerModules.stylix
            ./modules/home/stylix

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

            inputs.stylix.homeManagerModules.stylix
            ./modules/home/stylix

            inputs.sops-nix.homeManagerModules.sops
            ./shared/sops

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

        "cethien@hp-430-g7" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homes/cethien_hp-430-g7

            inputs.stylix.homeManagerModules.stylix
            ./modules/home/stylix

            inputs.sops-nix.homeManagerModules.sops
            ./shared/sops

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
    //
    {
      nixosConfigurations = {
        "tower-of-power" = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./systems/tower-of-power

            # inputs.disko.nixosModules.disko
            # ./shared/disko/simple

            inputs.sops-nix.nixosModules.sops
            ./shared/sops

            {
              system.stateVersion = stateVersion;
              networking.hostName = "tower-of-power";
              # disko.devices.disk.main.device = "/dev/nvme0n1";
            }
          ];

          specialArgs = {
            inherit inputs;
          };
        };

        "hp-430-g7" = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./systems/hp-430-g7

            inputs.disko.nixosModules.disko
            ./shared/disko/simple

            inputs.sops-nix.nixosModules.sops
            ./shared/sops

            {
              system.stateVersion = stateVersion;
              networking.hostName = "hp-430-g7";
              disko.devices.disk.main.device = "/dev/nvme0n1";
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
      };
    };


  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
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
}
