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
    in
    {
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
          fi
        '';
      };
    }
    // {
      homeConfigurations."cethien@lpt-sotnikow" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./homes/cethien_LPT-SOTNIKOW
        ];
      };

      homeConfigurations."cethien@tower-of-power" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homes/cethien_tower-of-power
        ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    }
    // {
      nixosConfigurations."tower-of-power" = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/tower-of-power
        ];

        specialArgs = {
          inherit inputs;
          meta = {
            hostname = "tower-of-power";
          };
        };
      };
    };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catppuccin.url = "github:catppuccin/nix";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
}
