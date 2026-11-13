{ lib, ... }:

{
  system.autoUpgrade = {
    enable = true;

    flake = "/data/dotfiles/";

    dates = "weekly";
    randomizedDelaySec = "45min";
    persistent = true;

    upgrade = false;

    operation = "switch";

    flags = [
      "--recreate-lock-file"
      "--commit-lock-file"

      "--option"
      "download-speed"
      "512"

      "--option"
      "connect-timeout"
      "10"

      "--option"
      "stalled-download-timeout"
      "60"
      "--fallback"
    ];
  };

  systemd.services.nixos-upgrade = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10min";
      Nice = 10;
      IOSchedulingClass = "idle";
    };

    startLimitIntervalSec = 24 * 60 * 60;
    startLimitBurst = 5;
  };

  systemd.timers.nixos-upgrade.timerConfig.OnCalendar = lib.mkForce [
    "weekly"
    "daily"
  ];

  systemd.services.nixos-upgrade.unitConfig.ConditionACPower = true;
}
