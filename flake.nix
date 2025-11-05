{
  description = "cethien's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    flake-utils,
    nixpkgs,
    nur,
    deploy-rs,
    nixos-hardware,
    disko,
    home-manager,
    ...
  }: let
    eachSys = flake-utils.lib.eachDefaultSystem;
    eachSysPass = flake-utils.lib.eachDefaultSystemPassThrough;
    pkgsFor = system:
      import nixpkgs {
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
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          just
          nixpkgs-fmt
          sops
          ansible
          ansible-lint
          sshpass
          openssl
          libargon2
        ];
      };

      packages.neovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {config = import ./modules/home/neovim/nvf-config.nix {inherit pkgs;};}
          ];
        }).neovim;
    })
    // eachSysPass (system: let
      pkgs = pkgsFor system;
      latestStateVersion = "25.05";
    in {
      homeConfigurations."bsotnikow@wsl" = home-manager.lib.homeManagerConfiguration {
        modules = [(import ./systems/tmsproshop.de/home.nix)];
        extraSpecialArgs = inputs // {stateVersion = latestStateVersion;};
        inherit pkgs;
      };

      nixosConfigurations."cethien.home" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          disko.nixosModules.disko
          ./shared/disko/simple
          ./systems/cethien.home/hardware.nix
          ./systems/cethien.home/configuration.nix
          {system.stateVersion = latestStateVersion;}
        ];
      };

      deploy.nodes."cethien.home" = {
        hostname = "192.168.1.50";
        profiles.system = {
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations."cethien.home";
          user = "root";
          sshUser = "deployrs";
          sshOpts = ["-i" "~/.ssh/id_deployrs_cethien.home"];
        };
      };

      nixosConfigurations."hp-430-g7" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = inputs;
        modules = let
          user = "cethien";
        in [
          ./systems/hp-430-g7/configuration.nix
          {system.stateVersion = latestStateVersion;}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "hm-bak";
              users."${user}" = ./systems/hp-430-g7/cethien-home.nix;
              extraSpecialArgs =
                inputs
                // {
                  stateVersion = latestStateVersion;
                  inherit pkgs system;
                };
            };
          }
        ];
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      templates = {
        default = self.templates.empty;

        empty = {
          path = ./templates/empty-project;
          description = "A basic project";
        };

        go = {
          path = ./templates/go-project;
          description = "go project";
        };
      };
    });
}
