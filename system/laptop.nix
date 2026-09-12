{
  pkgs,
  config,
  lib,
  ...
}:

{
  # Input & Tablet
  services.libinput.enable = true;
  hardware.sensor.iio.enable = true;
  services.xserver.wacom.enable = true;

  # Thermals managment
  services.thermald.enable = true;
  
  # Had to disable power-profiles so that tlp could work.
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";

      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 90;
      RESTORE_THRESHOLDS_ON_BAT = 1;
    };

  };

  # Lid & Power Buttons
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "hibernate";

    HandlePowerKeyLongPress = "poweroff";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = 1800;

  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate"; # or "PowerOff"
  };
}
