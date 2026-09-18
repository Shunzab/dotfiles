{
  pkgs,
  config,
  lib,
  ...
}:

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
    type = lib.types.enum [
      "latest"
      "zen"
      "lts"
    ];
    default = "latest";
    description = "Which kernel variant to use.";
  };

  options.mynixos.emeracc = lib.mkOption {
    # provides emergency access root shell initrd
    type = lib.types.bool;
    default = true;
    description = "whether to enable emergency access to shell";
  };

  options.mynixos.hibernation = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "whether to enable hibernation";
  };

  config = {
    boot = {
      kernelPackages = kernelMap.${cfg.kernel};
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
          # Fixed: Changed consoleMode to keep native framebuffer mode during shutdown
          consoleMode = "keep";
        };
        efi.canTouchEfiVariables = true;
        timeout = 10;
      };

      initrd.kernelModules = [
        "dm-snapshot"
        "dm-raid"
        "dm-crypt"
        "i915" # Keeps Intel graphics initialized
      ];

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "dm_mod"
        "dm_crypt"
        "cryptd"
      ];
      initrd.services.lvm.enable = true;

      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "rd.shell"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "systemd.show_status=false" # Added: Hides systemd status on main-system poweroff
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "bgrt_disable"
        # Removed: "vt.global_cursor_default=0" (causes DRM fallback issues)
      ];

      plymouth = {
        enable = true;
        theme = "connect";
        themePackages = [
          (pkgs.adi1090x-plymouth-themes.override {
            selected_themes = [
              "connect"
              "colorful_loop"
              "circuit"
              "cubes"
              "hexagon_hud"
              "cross_hud"
              "pixels"
            ];
          })
        ];
      };

      resumeDevice = if cfg.hibernation then "/dev/pool/swap" else "";
      initrd.systemd = {
        enable = true;
        emergencyAccess = cfg.emeracc;
        initrdBin = with pkgs; [
          iproute2
          pciutils
        ];
      };
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };
  };
}
