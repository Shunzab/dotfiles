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
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;
  services.flatpak.enable = true;
}
