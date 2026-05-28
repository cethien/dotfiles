{...}: {
  disko.devices.disk.main = {
    type = "disk";
    device = let
      envDisk = builtins.getEnv "TARGET_DISK";
    in
      if envDisk != ""
      then envDisk
      else "/dev/nvme0n1"; # Fallback
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "500M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            settings.allowDiscards = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
