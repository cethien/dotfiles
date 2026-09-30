from pathlib import Path
import subprocess
import yaml

key_file = Path.home() / ".config/sops/age/keys.txt"
if not key_file.exists():
    print(f"Key file not found: {key_file}")
    exit(1)

keys = []
for line in key_file.read_text().splitlines():
    line = line.strip()
    if line.startswith("AGE-SECRET-KEY-"):
        # Derive public key using age-keygen
        res = subprocess.run(
            ["age-keygen", "-y"],
            input=line,
            text=True,
            capture_output=True,
            check=True,
        )
        pub_key = res.stdout.strip()
        if pub_key:
            keys.append(pub_key)

if not keys:
    print("No age secret keys found.")
    exit(1)

data = {
    "keys": keys,
    "creation_rules": [
        {
            "path_regex": r"secrets(-[a-zA-Z0-9_-]+)?\.enc\.ya?ml$",
            "key_groups": [{"age": keys}],
        }
    ],
}

with open(".sops.yaml", "w") as f:
    yaml.dump(data, f, sort_keys=False, default_flow_style=False)

print(".sops.yaml successfully created.")
