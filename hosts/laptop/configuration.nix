{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    (inputs.self + "/system/boot.nix")
    (inputs.self + "/system/graphics.nix")
    (inputs.self + "/system/misc.nix")
    (inputs.self + "/system/laptop.nix")
    (inputs.self + "/system/networking.nix")
    (inputs.self + "/system/stylix.nix")
    (inputs.self + "/system/btrfs.nix")
    (inputs.self + "/system/virtualization.nix")
    (inputs.self + "/users/personal/personal.nix")
    (inputs.self + "/users/personal/gaming.nix")
    ./hardware-configuration.nix
    ./disko_dualboot.nix
  ];
  networking.hostName = "laptop";
  time.timeZone = "Asia/Karachi";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    cloudflare-warp
    tree
  ];

  services.cloudflare-warp.enable = true;

  mynixos.btrfs = {
    enable = true;
    user = "srs";
  };

  mynixos.waydroid = true;

  system.stateVersion = "26.05";
}
