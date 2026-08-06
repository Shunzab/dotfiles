{pkgs, config, lib, ...}:

let
  cfg = {
    kernel = config.mynixos.kernel;
    emeracc = config.mynixos.emeracc;
    hibernation = config.mynixos.hibernation;
  };
  kernelMap = {
    latest = pkgs.linuxPackages_latest;
    zen = pkgs.linuxPackages_zen; # the better one, in my opinion!
    lts = pkgs.linuxPackages_lts;
  };
in
{
  options.mynixos.kernel = lib.mkOption {  
    type = lib.types.enum [ "latest" "zen" "lts" ];  
    default = "zen";  
    description = "Which kernel variant to use.";  
  };  

  options.mynixos.emeracc = lib.mkOption { # provides emergency access root shell initrd
    type = lib.types.bool;  
    default = false;
    description = "whether to enable emergency access to shell";
  };

  options.mynixos.hibernation = lib.mkOption { 
    type = lib.types.bool;  
    default = true;
    description = "whether to enable hibernation";
  };

  config = {
    boot = {
      kernelPackages = kernelMap.${cfg.kernel}; # add kernel of your liking.
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
        timeout = 7;
      };

      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
          "quiet"
          "splash"
          "rd.shell"
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ];

      resumeDevice = if cfg.hibernation then "/dev/pool/swap" else ""; 
      initrd.systemd = {
        enable = true;
        emergencyAccess = cfg.emeracc; #to change, remember
        initrdBin = with pkgs; [iproute2 pciutils];
      };
    };

    swapDevices = [  
      {  
        device = "/dev/pool/swap";  
        priority = 20;  
      }  
    ];

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50; # uses up to 50% of your total ram for compressed swap
      priority = 100;
    };
  };
}
