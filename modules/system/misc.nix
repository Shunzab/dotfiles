{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # allow unfree software and flatpak
  nixpkgs.config.allowUnfree = true;
  #services.flatpak.enable = true;

  # services.printing.enable = true; # printing support

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-hyprland # Add this if you use Hyprland
      #pkgs.xdg-desktop-portal-wlr # if u use sway
    ];
    config = {
      common = {
        default = [ "gtk" ];
        # If you use Hyprland, change to:
        # default = [ "hyprland" "gtk" "wlr"];
      };
    };
  };
}
