{
  config,
  pkgs,
  lib,
  ...
}:
# to add wms, and different kinds of dms only of wayland.
let
  cfg = {
    kde = config.mynixos.kde;
    hyprland = config.mynixos.hyprland;
    sway = config.mynixos.sway;
    waylandUtils = config.mynixos.waylandUtils;
  };
  isWaylandWM = cfg.hyprland || cfg.sway;
in
{
  options.mynixos.kde = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable kde";
  };

  options.mynixos.sway = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable sway";
  };

  options.mynixos.hyprland = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable hyprland";
  };

  options.mynixos.waylandUtils = lib.mkOption {
    type = lib.types.bool;
    default = isWaylandWM;
    description = "Enable Wayland utilities (Waybar, Rofi, SwayNC, etc.)";
  };

  config = lib.mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
        ];
      };

      programs.sway = {
        enable = cfg.sway;
        xwayland.enable = true;
      };

      # all styling will be done in stylix module
      services.displayManager.regreet = {
        enable = cfg.sway || cfg.hyprland;
      };

      # for clean login when you have a login manager.
      systemd.services."getty@tty1".enable = !(isWaylandWM);
      systemd.services."autovt@tty1".enable = !(isWaylandWM);

    }

    (lib.mkIf cfg.hyprland {
      programs.hyprland = {
        enable = cfg.hyprland;
        xwayland.enable = true;
      };
      environment.systemPackages = with pkgs; [
        hyprpaper # Wallpaper daemon
        hyprlock # Screen locker
        hypridle # Idle management daemon (sleep/lock triggers)
        hyprpicker # Wayland color picker
        hyprsunset # Blue light filter
        hyprpolkitagent
      ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1"; # Force Electron apps to use native Wayland
      };
    })

    (lib.mkIf cfg.waylandUtils {
      programs = {
        waybar.enable = true;
      };
      services = {
        hypridle.enable = true;
      };

      hardware.uinput.enable = true;

      environment.systemPackages = with pkgs; [
        # Launchers
        fuzzel # Minimalist, insanely fast Wayland launcher
        swaynotificationcenter
        swayosd

        # Audio & Screen OSD
        pavucontrol # Audio control GUI
        playerctl # Media playback controls
        brightnessctl # Screen brightness controls (laptops/monitors)

        # Screenshots & Color Picker
        grim # Screenshot capture backend
        slurp # Screen region selection
        satty # Screenshot annotation tool

        # Clipboard Management
        wl-clipboard # Core Wayland clipboard CLI
        cliphist # Clipboard history manager

        # Utilities & System Info
        libnotify # Desktop notification trigger (notify-send)
        fastfetch # Modern system info fetch tool
        btop # Resource & process monitor
        imv # Lightweight image viewer
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    })

    (lib.mkIf cfg.kde {
      #services.xserver.enable = true; # use this if you strictly need x11.
      #stylix.targets.qt.platform = "qtct";
      services.displayManager = {
        sddm.enable = true;
        defaultSession = "plasma";
      };
      services.desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      programs.kde-pim.enable = false;
      services.power-profiles-daemon.enable = true;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        aurorae
        plasma-browser-integration
        plasma-workspace-wallpapers
        konsole
        kwin-x11
        ark
        elisa
        gwenview
        okular
        kate
        ktexteditor
        khelpcenter
        #dolphin
        baloo-widgets
        #dolphin-plugins
        spectacle
        ffmpegthumbs
        krdp
        #plasma-keyboard
        qtvirtualkeyboard
        union
      ];
    })
  ];
}
