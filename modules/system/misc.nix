{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Fonts of the system
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-color-emoji
      source-code-pro
      gentium
      nerd-fonts.jetbrains-mono # or whichever variant you want
    ];
    #fontconfig.defaultFonts = {
    #  serif = [ "Gentium" ];
    #  sansSerif = [ "DejaVu Sans" ];
    #  monospace = [ "Source Code Pro" ];
    #  emoji = [ "Twitter Color Emoji" ];
    #};
  };

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
  services.flatpak.enable = true;

  # services.printing.enable = true; # printing support
}
