# dotfiles (managed with nix)

## Requirements:

- NixOS or Nix Package Manager

## Installation

### NixOS

```bash
sudo nixos-rebuild switch \
--flake github:cethien/dotfiles#"$(hostname | tr 'A-Z' 'a-z')"
```

### Home-Manager

```bash
nix run nixpkgs#home-manager -- switch \
--flake github:cethien/dotfiles#"$(whoami)@$(hostname | tr 'A-Z' 'a-z')" -b bak-hm-"$(date +%Y%m%d_%H%M%S)"
```
