# "dotfiles"

NixOS client configs plus a single-host homelab setup.

## Homelab

The homelab host is defined statically in `hosts/default.nix` (no `inventory.toml` yet):

```nix
homelab = {
  hostName = "homelab";
  ip = "10.0.1.2";
};
```

Shared NixOS modules live in `modules/`; `modules/default.nix` imports the shared user
definition (`cethien`) so it is available to both clients and hosts.

Homelab services run as native NixOS/systemd units — no Docker, Arion or WUD.
System updates are handled by deploy-rs, so a container update notifier is redundant.
The system and NixOS modules stay on the stable `nixpkgs` input; only service binaries
(Caddy, Home Assistant, Matter Server, Homepage and Your Spotify) come from `pkgs-unstable`, the same
mixing pattern used by the clients. Each service keeps its own Caddy vhost and Homepage
card in its own file. `sysz` (an fzf TUI for systemctl) is in the common system
packages for inspecting/managing systemd units on the host.

The host is an HP t620 thin client running NixOS bare metal (no VM tooling).
Hardware config is generated on the target by `nixos-anywhere`, so there is no
checked-in `hardware.nix`. `hosts/homelab/disko.nix` targets the internal 29.8G
SATA disk `/dev/sda` (`sdb` is the Ventoy installer USB); override via `TARGET_DISK`.

Deployment uses the dedicated `nix-deploy` user (defined in
`hosts/_common/nix-deploy.nix`) and the key at `~/.ssh/nix-deploy` (generated with
the comment `nix-deploy@holzrussen.net`). The `booty` ISO already trusts that key for
`root` and carries the infra diagnostics (`check-nvme-wearout`, `bmon`).
`nixos-anywhere` bootstraps a fresh machine and also injects an age key derived from
that SSH key for future sops secrets.

Once the key is moved into KeePass (`~/.keep/vault.kdbx`, entry
`nix-deploy@holzrussen.net`, with the private key as an attachment), run
`doot bootstrap-sops`. It asks for the vault password, caches the SSH key at
`~/.cache/dotfiles/nix-deploy` (chmod 600), and derives the sops age identity into
`~/.config/sops/age/keys.txt`. `doot install-nixos` falls back to that cached key once
`~/.ssh/nix-deploy` is gone.

Caddy runs natively (`hosts/_common/caddy-cloudflare-tls.nix`, adapted from
`tms/infra`) with the Cloudflare DNS plugin; the API token comes from the
`cloudflare_api_token` sops secret. Each service declares its own route in its own
file, so the vhosts live beside what they proxy:

- `hosts/homelab/home-assistant.nix`: `ha.holzrussen.net` → `127.0.0.1:8123`
- `hosts/homelab/homepage/default.nix`: `holzrussen.net` → `127.0.0.1:8082`
- `hosts/homelab/your-spotify.nix`: `spotify.holzrussen.net` → client assets;
  `spotify-api.holzrussen.net` → `127.0.0.1:3000`

All use the `cloudflare_tls` snippet (Let's Encrypt DNS challenge). Ports 80/443 are
opened in `hosts/homelab/configuration.nix`; the backends stay on loopback.

Home Assistant and the Matter controller are native services in
`hosts/homelab/home-assistant.nix`:

- `services.home-assistant` listens on `127.0.0.1:8123` and trusts Caddy as a proxy.
  Config lives in `/var/lib/hass`; the host installs a minimal
  `configuration.yaml` from Nix, while UI-managed integrations/dashboards persist
  in that directory. HA 2026.8+ moved HTTP settings into `.storage/http`, so the
  host writes that store declaratively before each start (loopback bind, trusted
  proxy, no YAML
  `http:` block). This avoids the one-time YAML migration and the five-minute
  pending-config confirmation; HTTP settings changed in the UI are overwritten
  on restart.
- `services.matter-server` (`python-matter-server`) listens on `127.0.0.1:5580`, stores
  its fabric in `/var/lib/matter-server`, and starts fine with no devices paired.
  It is deliberately not firewall-exposed.

After deploy, finish HA setup in the UI:
1. Open `https://ha.holzrussen.net`, create the owner account.
2. Settings → Devices & Services → Add Integration → **Matter**. Point it at the
   Matter Server WebSocket: `ws://127.0.0.1:5580/ws`.
3. Add the **Thread** integration.

The two TIMMERFLOTTE sensors are Matter over **Thread** sleepy end devices — they
cannot form or extend a Thread mesh on their own. **There is no Thread Border Router
yet** and the plan is for HA to be the hub: add a Thread radio (e.g. Home Assistant
Connect ZBT-2 / EFR32) later and enable nixpkgs' `services.openthread-border-router`
with `backboneInterfaces` set for the LAN. Then pair the sensors to that border router
first, and add them to HA's Matter fabric. Until then, HA and Matter Server just idle
harmlessly.

Homepage (`hosts/homelab/homepage/default.nix`) uses the NixOS
`services.homepage-dashboard` module at `holzrussen.net` (port 8082, loopback only
behind Caddy). The old YAML files were folded into the module's `settings`, `services`,
`widgets` and `bookmarks` options; only `images/background.jpg` remains as a file and
is copied into the package's public images dir. Groups are ordered via the `layout`
list: `services` (Home Assistant and Your Spotify cards), then `infra` as a 2-column
row (GL.iNet router `http://172.16.1.1` and its AdGuard Home `http://172.16.1.1:3000`),
then the `Links` bookmarks to this repo and the Cloudflare dashboard. An ordered list is
required — a plain attr set would sort `infra` before `services`. Each service module
contributes its card to the `services` group through the `homelab.homepage.services`
option, so cards compose instead of duplicating the group. CPU/memory/disk/uptime/network
widgets read from `/` (no more `/host` bind mount).

Your Spotify (`hosts/homelab/your-spotify.nix`) runs the NixOS
`services.your_spotify` module with the unstable package, a local
`services.mongodb` (unauthenticated, loopback only) and the Node server on
`127.0.0.1:3000`. Caddy serves the prebuilt client on
`spotify.holzrussen.net` and reverse-proxies `spotify-api.holzrussen.net`
straight to the Node server. The API gets its own hostname because the Node
process only serves the API, while the UI is a separate static build; their
route names (`/artist`, `/album`, `/track`, …) also collide with the client
SPA routes, so a plain root-level reverse proxy only works on a dedicated API
hostname. Both names need DNS records pointing at the host. The Spotify
developer app credentials live in `secrets.enc.yml` as
`your_spotify/client_id` and `your_spotify/client_secret` (dummy values until
the app is created); set the app's redirect URI to
`https://spotify-api.holzrussen.net/oauth/spotify/callback`.

Your Spotify polls the Spotify API on its own — there is no manual "fetch"
button. The loop runs every ~2 minutes and the first pass backfills the last
24 hours, so the dashboard can stay empty for a couple of minutes after login
(or until something is played). Follow it with
`journalctl -u your_spotify -f`; it logs `refreshing...` and then the number of
tracks/albums/artists written. For listening history older than that, use
Settings → Account → **Import data** with a Spotify account-data export. If
sync stops with 401/403 errors, use **Relog to Spotify** on the same page.

In the devshell, use `doot`:

```bash
doot install-nixos homelab 10.0.1.2        # bootstrap a fresh host
doot deploy homelab --diff                 # deploy via deploy-rs (with remote diff)
doot diff-nixos-host homelab               # show remote closure diff only
doot update --repo                         # update disko/sops-nix/deploy-rs
```

`DOTFILES_DEPLOY_KEY` overrides the SSH key used by `install-nixos`.
