{
  description = "cethien's dotfiles";


  outputs = inputs @ { nixpkgs, home-manager, ... }: 
  let    
    allowedHosts = [ "holzrussen-hq" "PC-SOTNIKOW" "LTP-SOTNIKOW" "surface-7"];
    
    defaults = {
      
      system = {
        host = "holzrussen-hq";
      };

      user = {
        username = "cethien";
        name = "Boris";
      };

    };

    cfgFile = if builtins.pathExists ./config.toml
              then builtins.fromTOML (builtins.readFile ./config.toml)
              else {};
    
    system = {
      system = "x86_64-linux";
      host = if builtins.hasAttr "host" cfgFile 
                then if builtins.elem cfgFile.host allowedHosts
                     then cfgFile.host
                     else abort "Host '${cfgFile.device}' is not allowed. Allowed hosts are: ${builtins.toJSON allowedHosts}"
                else defaults.system.host;
    };

    user = {
      username = if builtins.hasAttr "username" cfgFile 
                then cfgFile.username
                else defaults.user.username;
      name = if builtins.hasAttr "name" cfgFile 
                then cfgFile.name
                else defaults.user.name;
    };

    isNixos = builtins.elem system.host [ "holzrussen-hq" "surface-7" ];
    isOtherLinux = builtins.elem system.host [ "PC-SOTNIKOW" "LTP-SOTNIKOW" ];

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = if isNixos then {
      "${system.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = { 
          inherit inputs system user; 
        };

        modules = with inputs; [
         ./configuration.nix
         catppuccin.nixosModules.catppuccin
        ];
      }; 
   } else {};

    homeConfigurations = if isOtherLinux then {
      "${user.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
      
        extraSpecialArgs = {
          inherit inputs user;
        };

        modules = [
          ./home.nix
        ];
      };
    } else {};  
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    
    catppuccin.url = "github:catppuccin/nix";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
