{
  disko.devices = {
    disk = {
      boot_part = {
        type = "disk";
        device = "/dev/nvme0n1p6"; # Replace with your newly created 1GB EFI partition path
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      nixos_part = {
        type = "disk";
        device = "/dev/nvme0n1p7"; # Replace with your newly created Linux partition path
        content = {
          type = "luks";
          name = "cryptroot";
          settings.allowDiscards = true;
          content = {
            type = "lvm_pv";
            vg = "pool";
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "24G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/@snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/@data" = {
                  mountpoint = "/data";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
