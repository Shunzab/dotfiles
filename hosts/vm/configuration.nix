{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    (inputs.self + "/modules/system/boot.nix")
    (inputs.self + "/modules/system/graphics.nix")
    (inputs.self + "/modules/system/misc.nix")
    (inputs.self + "/modules/system/networking.nix")
    (inputs.self + "/modules/system/stylix.nix")
    (inputs.self + "/modules/users/personal/personal.nix")
    ./hardware-configuration.nix
  ];

  time.timeZone = "Asia/Karachi";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
  ];
  system.stateVersion = "26.05";
}
