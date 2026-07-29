{
  description = "cethien's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unstable";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixcord.url = "github:FlameFlag/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    bash-prompt-prefix = "[devshell] ";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    stateVersion = "25.05";
    system = "x86_64-linux";

    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;

        overlays = [inputs.firefox-addons.overlays.default];
      };
      firefox-addons = final.unstable.firefox-addons;
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};

      fzf = final.unstable.fzf;

      hyprland = final.unstable.hyprland;
      steam = final.unstable.steam;

      tmux = final.unstable.tmux;
      tmuxPlugins = final.unstable.tmuxPlugins;
      keepassxc = final.unstable.keepassxc;
      thunderbird = final.unstable.thunderbird;
      libreoffice-fresh = final.unstable.libreoffice-fresh;

      spotify-player = final.unstable.spotify-player;

      spotify = final.unstable.spotify;
      discord = final.unstable.discord;
      vesktop = final.unstable.vesktop;
      slack = final.unstable.slack;
    };

    globalNixpkgsModule = {
      nixpkgs.config.allowUnfree = true;

      nixpkgs.overlays = [
        unstableOverlay
        inputs.nix-gaming.overlays.default
      ];
    };

    clientNames = ["tms-bso" "tower-of-power" "hp-430-g7"];
  in {
    nixosConfigurations = builtins.listToAttrs (map (name: {
        inherit name;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;} // inputs;
          modules = [
            globalNixpkgsModule
            ./clients/_common/configuration.nix
            ./clients/${name}/hardware-configuration.nix
            ./clients/${name}/configuration.nix
            {
              system = {inherit stateVersion;};
              networking.hostName = name;
              _module.args = {
                hostName = name;
                inherit stateVersion;
              };
            }
          ];
        };
      })
      clientNames);

    packages.${system} = let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      doot = pkgs.callPackage ./packages/doot {};
      booty =
        (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [./booty/configuration.nix];
        }).config.system.build.isoImage;
    };

    devShells.${system} = let
      pkgs = nixpkgs.legacyPackages.${system};
      doot = self.packages.${system}.doot;
    in {
      default = import ./shell.nix {inherit pkgs doot;};
    };

    templates = import ./templates;
  };
}
