{
  description = "cethien's dotfiles";

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [nur.overlays.default];
    };
    stateVersion = "25.05";
  in {
    nixosConfigurations.liveIso = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./systems/liveIso/configuration.nix
        {
          system.stateVersion = stateVersion;
        }
      ];
    };

    nixosConfigurations."homelab" = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      modules = [
        ./systems/homelab/configuration.nix
        {
          system.stateVersion = stateVersion;
        }
        disko.nixosModules.disko
        ./systems/homelab/disko.nix
        ./systems/homelab/hardware.nix
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
        ./systems/hp-430-g7/configuration.nix
        {
          system.stateVersion = stateVersion;
        }
        ./systems/hp-430-g7/hardware.nix
      ];
    };

    homeConfigurations."cethien@hp-430-g7" = import ./homes/cethien_hp-430-g7 {
      inherit pkgs system home-manager stateVersion sops-nix stylix hyprpanel zen-browser nvf;
    };

    nixosConfigurations."tower-of-power" = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      modules = [
        ./systems/tower-of-power/configuration.nix
        {
          system.stateVersion = stateVersion;
          boot.kernelPackages = pkgs.linuxPackages_zen;
        }
        ./systems/tower-of-power/hardware.nix
      ];
    };

    homeConfigurations."cethien@tower-of-power" = import ./homes/cethien_tower-of-power {
      inherit pkgs system home-manager stateVersion sops-nix stylix hyprpanel zen-browser nvf;
    };

    homeConfigurations."cethien@wsl" = import ./homes/cethien_wsl {
      inherit pkgs system home-manager stateVersion sops-nix stylix nvf;
    };

    # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    packages.${system} = let
      neovimConf = nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            config = import ./modules/home/programs/neovim/nvf-config.nix {
              inherit pkgs;
            };
          }
        ];
      };
    in {
      neovim = neovimConf.neovim;
      v = neovimConf.neovim;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        just
        sops

        ansible
        ansible-lint
        sshpass
      ];
    };
  };

  inputs = {
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
