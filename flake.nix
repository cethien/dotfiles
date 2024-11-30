{
  description = "cethien's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
   
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
  let
    os = "nixos";

    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = if os == "nixos" then {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs inputs system; };

        modules = [
         inputs.catppuccin.nixosModules.catppuccin
         ./configuration.nix
        ];
      }; 
   } else {};

   homeConfigurations = if os != "nixos" then {
       cethien = home-manager.lib.homeManagerConfiguration {
       extraSpecialArgs = {
         inherit pkgs inputs;
       };

       modules = [
          inputs.catppuccin.homeManagerModules.catppuccin
          ./home.nix
       ];
     };
    } else {};  
  };
}
