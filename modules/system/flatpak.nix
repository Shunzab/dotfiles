{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak.enable = true;

  services.flatpak.packages = [
    "md.obsidian.Obsidian"
    "org.mozilla.firefox"
  ];

  services.flatpak.update.onActivation = true;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.overrides = {
    global = {
      Context = {
        sockets = [
          "wayland"
          "fallback-x11"
          "network"
        ];
        devices = [ "dri" ];
        filesystems = [
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
          "xdg-config/Kvantum:ro"
          "~/.themes:ro"
          "~/.icons:ro"
          "xdg-data/themes:ro"
          "xdg-data/icons:ro"
          "/nix/store:ro"
          "!home"
        ];
        Environment = {
          GTK_THEME = "Adwaita:dark"; # remember to put in stylix config too, so that gtk4 apps can also be themed
        };
        talk-to-bus = [
          "org.freedesktop.portal.Desktop"
          "org.freedesktop.Notifications"
        ];
      };
    };

    "md.obsidian.Obsidian" = {
      Context.filesystems = [
        "~/Documents/obsidian_vaults:create"
        "xdg-download"
      ];
    };

    "org.mozilla.firefox" = {
      Context.filesystems = [
        "xdg-download"
        "!home"
      ];
    };

    "com.github.IsmaelMartinez.teams_for_linux" = {
      Context = {
        sockets = [ "x11" ];
        devices = [ "all" ];
        filesystems = [ "xdg-download" ];
      };
    };
  };
}
