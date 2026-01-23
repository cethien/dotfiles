{
  description = "cethien's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs-unstable";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs @ {
    self,
    flake-utils,
    nixpkgs,
    nixos-hardware,
    disko,
    deploy-rs,
    nixpkgs-unstable,
    home-manager,
    nur,
    ...
  }: let
    stateVersion = "25.05";
    eachSys = flake-utils.lib.eachDefaultSystem;
    eachSysPass = flake-utils.lib.eachDefaultSystemPassThrough;

    pkgsFor = system: import nixpkgs {inherit system;};

    pkgsUnstableFor = system:
      import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/cethien.nix)
          nur.overlays.default
        ];
      };
  in
    eachSys
    (system: let
      pkgs = pkgsFor system;
    in {
      devShells.default = import ./devShell.nix {inherit pkgs;};
    })
    // eachSysPass (system: let
      pkgs = pkgsFor system;
      hosts = import ./hosts;
      hostConfigs =
        builtins.mapAttrs
        (
          name: n:
            nixpkgs.lib.nixosSystem {
              inherit pkgs;
              modules = [
                disko.nixosModules.disko
                (import ./disko/simple.nix {inherit (n) diskId;})
                ./hosts/${n.hostName}/hardware-configuration.nix
                ./hosts/${n.hostName}/configuration.nix
                {
                  system = {inherit stateVersion;};
                  networking = {
                    inherit (n) hostName;
                    interfaces.eth0.ipv4.addresses = [
                      {
                        inherit (n) address;
                        prefixLength = 24;
                      }
                    ];
                    inherit (n) defaultGateway nameservers;
                  };
                }
              ];
            }
        )
        hosts;

      pkgsUnstable = pkgsUnstableFor system;
      clients = import ./clients;
      clientConfigs =
        builtins.mapAttrs
        (name: n:
          nixpkgs-unstable.lib.nixosSystem
          {
            pkgs = pkgsUnstable;
            modules = let
              user = "cethien";
            in [
              disko.nixosModules.disko
              (import ./disko/simple.nix {inherit (n) diskId;})
              ./clients/${n.hostName}/hardware-configuration.nix
              ./clients/${n.hostName}/configuration.nix
              {system = {inherit stateVersion;};}

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hm-bak";
                  users."${user}" = ./clients/${n.hostName}/home.nix;
                  extraSpecialArgs =
                    inputs
                    // {
                      pkgs = pkgsUnstable;
                      inherit system stateVersion;
                    };
                };
              }
            ];
            specialArgs = inputs // {nixpkgs = nixpkgs-unstable;};
          })
        clients;

      homes = import ./homes;
      homeConfigs = builtins.listToAttrs (map
        (n: let
          host =
            if n.type == "wsl"
            then "wsl"
            else n.hostname;
        in {
          name = "${n.username}@${host}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsUnstable;
            modules = [
              (import ./homes/${n.hostname})
              {
                home = let
                  inherit (n) username;
                in {
                  inherit stateVersion username;
                  homeDirectory = "/home/${username}";
                };
              }
            ];
            extraSpecialArgs = inputs;
          };
        })
        homes);
    in {
      homeConfigurations = homeConfigs;
      nixosConfigurations = hostConfigs // clientConfigs;

      deploy.nodes =
        builtins.mapAttrs
        (_: n: {
          hostname = n.address;
          profiles.system = {
            user = "root";
            sshUser = "deployrs";
            sshOpts = ["-i" "~/.ssh/id_deployrs_cethien.home"];
            path =
              deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.${n.hostName};
          };
        })
        hosts;

      checks =
        builtins.mapAttrs
        (system: deployLib:
          deployLib.deployChecks self.deploy)
        deploy-rs.lib;

      templates = import ./templates;
    }) // {
      homeModules.default = import ./modules/home;
      homeManagerModules = self.homeModules;
    };
}
