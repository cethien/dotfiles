#!/usr/bin/env python3

import sys
import tomllib
from ipaddress import IPv4Address
from pathlib import Path

INVENTORY_FILE = Path("inventory.toml")


def validate_homes(homes: dict) -> bool:
    has_errors = False
    for name, home in homes.items():
        user = home.get("user")

        if not user:
            print(f"❌ missing 'user' for home: {name}")
            has_errors = True
            continue

    return has_errors


def validate_clients(clients: dict) -> bool:
    has_errors = False
    for name, client in clients.items():
        disk_id = client.get("disk_id")

        if not disk_id:
            print(f"❌ missing 'disk_id' for client: {name}")
            has_errors = True
            continue

    return has_errors


def validate_services(hosts: dict, clusters: dict, services: dict) -> bool:
    has_errors = False
    host_names = hosts.keys()
    cluster_names = clusters.keys()

    for svc_name, svc in services.items():
        host = svc.get("host")
        cluster = svc.get("cluster")

        if not host and not cluster:
            print(f"❌ service {svc_name} needs either a host or a cluster")
            has_errors = True

        if host and host not in host_names:
            print(f"❌ service {svc_name} references unknown host {host}")
            has_errors = True

        if cluster and cluster not in cluster_names:
            print(f"❌ service {svc_name} references unknown cluster {cluster}")
            has_errors = True

    return has_errors


def validate_hosts(hosts: dict) -> bool:
    has_errors = False
    seen = {}

    for name, host in hosts.items():
        addr = host.get("address")

        if not addr:
            print(f"❌ missing 'address' for host: {name}")
            has_errors = True
            continue

        try:
            IPv4Address(addr)
        except ValueError:
            print(f"❌ invalid IPv4 address on host {name}: {addr}")
            has_errors = True
            continue

        if addr in seen:
            print(f"❌ duplicate IPv4 address {addr} (hosts: {seen[addr]} and {name})")
            has_errors = True
        else:
            seen[addr] = name

    return has_errors


def load_inventory(path: Path) -> dict:
    try:
        with open(path, "rb") as f:
            return tomllib.load(f)
    except FileNotFoundError:
        print(f"❌ inventory file not found: {path}")
        sys.exit(1)
    except tomllib.TOMLDecodeError as e:
        print(f"❌ invalid TOML in {path}: {e}")
        sys.exit(1)


def main():
    data = load_inventory(INVENTORY_FILE)

    errors = False

    hosts = data.get("hosts", {})
    errors |= validate_hosts(hosts)

    clusters = data.get("clusters", {})
    services = data.get("services", {})
    errors |= validate_services(hosts, clusters, services)

    clients = data.get("clients", {})
    errors |= validate_clients(clients)

    homes = data.get("homes", {})
    errors |= validate_homes(homes)

    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
