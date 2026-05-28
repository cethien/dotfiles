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

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs-unstable";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs-unstable";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs-unstable";

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
    flake-utils,
    nixpkgs,
    nixos-hardware,
    disko,
    deploy-rs,
    nixpkgs-unstable,
    home-manager,
    nix-index-database,
    ...
  }: let
    stateVersion = "25.05";

    pkgsFor = system: import nixpkgs {inherit system;};

    pkgsUnstableFor = system:
      import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.firefox-addons.overlays.default
          inputs.nix-gaming.overlays.default
        ];
      };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = pkgsFor system;
      doot = pkgs.callPackage ./packages/doot {};
      booty =
        (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./booty/configuration.nix
          ];
        }).config.system.build.isoImage;
    in {
      packages = {
        inherit doot booty;
      };

      devShells.default = import ./shell.nix {inherit pkgs doot;};
    })
    // flake-utils.lib.eachDefaultSystemPassThrough (system: let
      pkgsUnstable = pkgsUnstableFor system;

      clientNames = [
        "tms-bso"
        "tower-of-power"
        "hp-430-g7"
      ];

      clients = builtins.listToAttrs (map (name: {
          inherit name;
          value = nixpkgs-unstable.lib.nixosSystem {
            pkgs = pkgsUnstable;
            specialArgs = {inherit inputs;} // inputs;
            modules = [
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
    in {
      nixosConfigurations = clients;

      templates = import ./templates;
    });
}
