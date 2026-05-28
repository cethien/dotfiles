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
          type = "EF00";
          size = "500M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
