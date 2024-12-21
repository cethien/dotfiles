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

      homelabNodes = [
        "homelab-01"
      ];
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          just
          nil
          nixpkgs-fmt
        ];

        shellHook = ''
          if [ ! -f .envrc ]; then
            echo "use flake" > .envrc && direnv allow
          fi
        '';
      };

      homeConfigurations."cethien" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/wsl/home.nix ];
      };

      nixosConfigurations = {
        "surface-7-pro" = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            meta = {
              hostname = "surface-7-pro";
            };
          };

          system = "x86_64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            { disko.devices.disk.disk1.device = "/dev/nvme0n1"; }
            ./hosts/surface-7-pro/configuration.nix
          ];
        };

        "tower-of-power" = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            meta = {
              hostname = "tower-of-power";
            };
          };

          modules = [
            ./hosts/tower-of-power/configuration.nix
          ];
        };
      } // builtins.listToAttrs (map
        (node: {
          name = node;
          value = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              meta = {
                hostname = node;
              };
            };
            system = "x86_64-linux";
            modules = [
              inputs.disko.nixosModules.disko
              ./hosts/${node}/hardware-configuration.nix
              ./hosts/homelab/disk-config.nix
              ./hosts/homelab/configuration.nix
            ];
          };
        })
        homelabNodes);
    };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
}
