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

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    deploy-rs,
    nixos-hardware,
    disko,
    sops-nix,
    home-manager,
    nur,
    stylix,
    nvf,
    hyprpanel,
    zen-browser,
    ...
  }: let
    eachSys = flake-utils.lib.eachDefaultSystem;
    eachSysPass = flake-utils.lib.eachDefaultSystemPassThrough;
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [nur.overlays.default];
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
        ];
      };

      packages.neovim =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {config = import ./modules/home/programs/neovim/nvf-config.nix {inherit pkgs;};}
          ];
        }).neovim;
    })
    // eachSysPass (system: let
      pkgs = pkgsFor system;
      stateVersion = "25.05";
    in {
      nixosConfigurations.liveIso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./systems/liveIso/configuration.nix
          {system.stateVersion = stateVersion;}
        ];
      };

      nixosConfigurations."homelab" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          disko.nixosModules.disko
          ./systems/homelab/disko.nix
          ./systems/homelab/hardware.nix
          ./systems/homelab/configuration.nix
          {system.stateVersion = stateVersion;}
        ];
      };

      deploy.nodes."homelab" = {
        hostname = "192.168.0.23";
        profiles.system = {
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.homelab;
          user = "root";
          sshUser = "deployrs";
          sshOpts = ["-i" "~/.ssh/deployrs_cethien.home"];
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      nixosConfigurations."hp-430-g7" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          nixos-hardware.nixosModules.common-pc-laptop
          ./systems/hp-430-g7/hardware.nix
          ./systems/hp-430-g7/configuration.nix
          {system.stateVersion = stateVersion;}
        ];
      };

      homeConfigurations."cethien@hp-430-g7" = import ./homes/cethien_hp-430-g7 {
        inherit
          pkgs
          system
          home-manager
          stateVersion
          sops-nix
          stylix
          hyprpanel
          zen-browser
          nvf
          ;
      };

      nixosConfigurations."tower-of-power" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./systems/tower-of-power/hardware.nix
          ./systems/tower-of-power/configuration.nix
          {
            system.stateVersion = stateVersion;
            boot.kernelPackages = pkgs.linuxPackages_zen;
          }
        ];
      };

      homeConfigurations."cethien@tower-of-power" = import ./homes/cethien_tower-of-power {
        inherit
          pkgs
          system
          home-manager
          stateVersion
          sops-nix
          stylix
          hyprpanel
          zen-browser
          nvf
          ;
      };

      homeConfigurations."cethien@wsl" = import ./homes/cethien_wsl {
        inherit
          pkgs
          system
          home-manager
          stateVersion
          sops-nix
          stylix
          nvf
          ;
      };

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
