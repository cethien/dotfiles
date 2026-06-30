# ⚡ Home Manager Kickstart

Your Home Manager configuration environment is ready in `~/home-manager`.

## 🚀 Getting Started

1. **Verify Username:**
   The installation script automatically attempted to inject your system user into `flake.nix`.
   Please double-check `flake.nix` at `username = "..."` to ensure it matches your environment.

2. **Run Initial Build:**
   Execute the following command inside the `~/home-manager`

```bash
    nix run nixpkgs#home-manager -- switch --flake . --backup-extension backup
```

## 🛠️ Customization & Packages

- **Adding Packages:**
  Open `home.nix`. You can declare additional CLI utilities line-by-line inside the `home.packages` list.
- **Searching Options:**
  Home Manager options are integrated into the official Nixos search engine. Set the toggle to "Home Manager" to look up configuration flags:
  👉 https://search.nixos.org/options?channel=26.05&source=home_manager
- **Development Tooling:**
  Run `nix develop` inside this directory to spawn a shell pre-configured with language servers (`nixd`, `lua-language-server`) and formatters (`alejandra`, `stylua`) for your editor setup.
