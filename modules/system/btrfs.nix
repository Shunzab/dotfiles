# To enable it:
#  mynixos.btrfs = {
#     enable = true;
#     user = "srs";
#  };

{ config, lib, ... }:
let
  cfg = config.mynixos.btrfs;
in
{
  options.mynixos.btrfs = {
    enable = lib.mkEnableOption "Btrfs maintenance and Snapper snapshots";

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Username permitted to view and restore snapshots";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.auto-optimise-store = true;
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    services.snapper = {
      snapshotInterval = "hourly";
      configs = {
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ cfg.user ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = "5";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "12";
        };
      };
    };
  };
}
