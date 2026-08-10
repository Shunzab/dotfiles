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

  stylix = {
    enable = true;
    autoEnable = true;

    # Base configuration
    # image = ./wallpaper.png;
    polarity = "dark"; # "dark", "light", or "either"
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";

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
        package = pkgs.nerd-fonts.jet-brains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
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

    iconTheme = {
      enable = true;
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-dark";
      light = "Tela-circle";
    };

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 0.9;
    };

    targets = {
      tmux.enable = false;
      #neovim.enable = false;
    };
  };
}
