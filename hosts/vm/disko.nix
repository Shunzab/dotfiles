{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; 
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ]; 
              };
            };
            SWAP = {
              size = "24G"; 
	      content = {
                type = "luks";
                name = "cryptswap";
                settings = {
                  allowDiscards = true; 
                };
                content = {
                  type = "swap";
                  resumeDevice = true; 
                };
              };
            };
            NIXOS = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryproot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; 
		  #passwordFile = "../../../secret_file.txt"
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@data" = {
                      mountpoint = "/data";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@logs" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
