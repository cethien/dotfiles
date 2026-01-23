# "dotfiles"

my dotfiles... and setup scripts... and system configurations... and server
infra...

## requirements:

- [NixOS](https://nixos.org/) / any distro with Nix Package Manager

## remote usage

### bootstrapping (home-manager)

installs nix + home-manager, sets some permissions.

check [`file`](./bootstrap.sh) for details.

```bash
sh <(curl -fsSL -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/cethien/dotfiles/main/bootstrap.sh")
```

### neovim

_`i use vim btw`_ 🤓

_`are you really 10x without vim motions?`_ 🤓

build neovim from remote.

not sure about installing, will look into it later (famous last words)

```bash
nix run github:cethien/dotfiles#neovim
```

### build home from remote

_doesn't need existing home manager instance_

```bash
nix run nixpkgs#home-manager -- switch \
--flake github:cethien/dotfiles#"$(whoami)@$(hostname | tr 'A-Z' 'a-z')" -b bak-hm-"$(date +%Y%m%d_%H%M%S)"
```

includes also 2 console aliases:

- `rebuild` to build home from remote
- `rebuild-os` to build system from remote... speaking of:

### build nixos

well, you should have nixos installed, otherwise... will do nuthin' (well, it
will error, but thats basically nuthin')

```bash
sudo nixos-rebuild switch \
--flake github:cethien/dotfiles#"$(hostname | tr 'A-Z' 'a-z')"
```
