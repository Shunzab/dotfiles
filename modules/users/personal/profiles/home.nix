{ config, lib, pkgs, inputs, ... }:


{
  home.username = "srs";
  home.homeDirectory = "/home/srs";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05"; # no changing this

  home.packages = with pkgs; [
    fastfetch
  ];
}

