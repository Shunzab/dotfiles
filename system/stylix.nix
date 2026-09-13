{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

# I haven't selected my fonts and themes just yet. They will be selected once I have an up and running system.
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;

    # Base configuration
    # image = ./wallpaper.png;
    polarity = "dark"; # "dark", "light", or "either"
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml"; 

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-dark";
      light = "Tela-circle";
    };

    opacity = {
      applications = 0.85;
      terminal = 0.85;
      desktop = 0.75;
      popups = 0.80;
    };
  };

  stylix.targets.plymouth.enable = false;
}
