{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    (inputs.self + "/system/boot.nix")
    (inputs.self + "/system/graphics.nix")
    (inputs.self + "/system/misc.nix")
    (inputs.self + "/system/networking.nix")
    (inputs.self + "/system/stylix.nix")
    (inputs.self + "/users/personal/personal.nix")
    ./disko.nix
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
