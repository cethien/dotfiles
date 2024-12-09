{
  description = "cethien's dotfiles";


  outputs = inputs @ { nixpkgs, home-manager, ... }: 
  let    
    allowedHosts = [ "holzrussen-hq" "PC-SOTNIKOW" "LTP-SOTNIKOW" "surface-7"];
    
    system = {
      host = "holzrussen-hq";

      system = "x86_64-linux";
      profile = {
        isNixos = builtins.elem system.host [ "holzrussen-hq" "surface-7" ];
        isHomePC = builtins.elem system.host [ "holzrussen-hq" ];
        isSurface = builtins.elem system.host [ "surface-7" ];
        isWSL = builtins.elem system.host [ "PC-SOTNIKOW" "LTP-SOTNIKOW" ];
      };
    };

    user = {
      username = "cethien";
      name = "Boris";
      authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
      ];
    };

    pkgs = import nixpkgs {
      system = system.system;
      config.allowUnfree = true;
      overlays = [ inputs.nur.overlay ];
    };
  in
  {
    nixosConfigurations = if system.profile.isNixos then {
      "${system.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = { 
          inherit inputs system user; 
        };

        modules = [
         ./configuration.nix
        ];
      }; 
   } else {};

    homeConfigurations = if !system.profile.isNixos then {
      "${user.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
      
        extraSpecialArgs = {
          inherit inputs system user;
        };

        modules = [
          ./home.nix
        ];
      };
    } else {};  
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    catppuccin.url = "github:catppuccin/nix";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
