# "dotfiles"

my dotfiles... and setup scripts... and system configurations... and server
infra...

## requirements:

- [NixOS](https://nixos.org/) / any distro with Nix Package Manager

## remote usage

### setup home

for first time installation. this installs nix, sets some permissions and builds
home-manager. check [`setup file`](./setup-home.sh) for details.

```bash
sh <(curl -fsSL -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/cethien/dotfiles/main/setup-home.sh")
```

### rebuild home

doesn't need existing home manager instance

```bash
nix run nixpkgs#home-manager -- switch \
--flake github:cethien/dotfiles#"$(whoami)@$(hostname | tr 'A-Z' 'a-z')" -b bak-hm-"$(date +%Y%m%d_%H%M%S)"
```

### rebuild nixos

this assumes nixos is already installed

```bash
sudo nixos-rebuild switch \
--flake github:cethien/dotfiles#"$(hostname | tr 'A-Z' 'a-z')"
```
