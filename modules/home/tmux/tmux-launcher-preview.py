import argparse
import subprocess
from colorama import Fore, Style


def run_cmd(cmd, timeout=3):
    try:
        res = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        return res.stdout.strip()
    except Exception:
        return ""


def preview_ssh(host):
    ssh_opts = [
        "-o",
        "BatchMode=yes",
        "-o",
        "ConnectTimeout=2",
        "-o",
        "StrictHostKeyChecking=accept-new",
    ]

    # Local SSH Config Infos
    ssh_cfg = run_cmd(f"ssh -G {host}")
    if ssh_cfg:
        keys = ["user", "hostname", "port", "identityfile"]
        for line in ssh_cfg.splitlines():
            parts = line.split(maxsplit=1)
            if parts and parts[0].lower() in keys and len(parts) == 2:
                label = f"{parts[0]:<14}"
                print(f"{Fore.GREEN}{label}{Style.RESET_ALL} {parts[1]}")
        print()

    # Remote Commands sauber umgebrochen
    cmd_os = (
        "cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | "
        "cut -d= -f2 | tr -d '\"' || uname -sr"
    )
    cmd_up = "uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}'"
    cmd_cpu = (
        "grep 'cpu ' /proc/stat 2>/dev/null | awk "
        "'{usage=($2+$4)*100/($2+$4+$5)} END {printf \"%.1f%%\", usage}'"
    )
    cmd_mem = (
        "free -h 2>/dev/null | awk '/Mem:/ "
        '{print $3 " / " $2 " (Available: " $7 ")"}\''
    )
    cmd_df = (
        "df -h -x tmpfs -x devtmpfs -x overlay 2>/dev/null | "
        "grep -E '^/dev/' | awk '{printf "
        '"%s %s / %s (%s) -> %s\\n", $1, $3, $2, $5, $6}\''
    )

    cmds = [cmd_os, cmd_up, cmd_cpu, cmd_mem, cmd_df]
    payload = " && echo '---DELIM---' && ".join(cmds)

    try:
        proc = subprocess.run(
            ["ssh"] + ssh_opts + [host, payload],
            capture_output=True,
            text=True,
            timeout=3,
        )
        if proc.returncode == 0 and proc.stdout:
            out = proc.stdout.split("---DELIM---")
            if len(out) >= 5:
                metrics = [
                    ("OS:", out[0]),
                    ("Uptime:", out[1]),
                    ("CPU Load:", out[2]),
                    ("Memory:", out[3]),
                ]
                for lbl, val in metrics:
                    res_lbl = f"{lbl:<12}"
                    res_val = val.strip()
                    print(f"{Fore.CYAN}{res_lbl}{Style.RESET_ALL} {res_val}")

                print()
                for line in out[4].strip().splitlines():
                    p = line.split(maxsplit=4)
                    if len(p) == 5:
                        dev = f"{p[0]:<12}"
                        stats = f"{p[1]} / {p[2]} ({p[3]}) -> {p[4]}"
                        print(f"{Fore.CYAN}{dev}{Style.RESET_ALL} {stats}")
        else:
            if proc.stderr:
                err = proc.stderr.strip().splitlines()[-1]
            else:
                err = "Unreachable"
            print(f"{Fore.RED}{err}{Style.RESET_ALL}")
    except subprocess.TimeoutExpired:
        print(f"{Fore.RED}Connection timeout{Style.RESET_ALL}")


def preview_docker(host):
    fmt = "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    cmd = (
        f"ssh -o BatchMode=yes -o ConnectTimeout=2 -q {host} "
        f"'docker ps --format \"{fmt}\"'"
    )
    out = run_cmd(cmd, timeout=3)
    if out:
        print(out)
    else:
        err_msg = (
            f"{Fore.RED}Docker on {host} not reachable or "
            f"no containers{Style.RESET_ALL}"
        )
        print(err_msg)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-t",
        "--type",
        required=True,
        choices=["ssh", "docker"],
    )
    parser.add_argument("-H", "--host", required=True)
    args = parser.parse_args()

    if args.type == "ssh":
        preview_ssh(args.host)
    elif args.type == "docker":
        preview_docker(args.host)


if __name__ == "__main__":
    main()
