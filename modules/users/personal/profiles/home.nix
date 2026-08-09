{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "srs";
  home.homeDirectory = "/home/srs";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05"; # no changing this

  home.packages = with pkgs; [
    fastfetch
  ];

  programs.git = {
    enable = true;

    ignores = [
      ".direnv/"
      ".envrc"
      "*.swp"
      ".DS_Store"
      "result"
      "result-*"
    ];

    userName = "Shunzab Asad";
    userEmail = "shunzab.asad@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3"; # Modern 3-way merge conflict style
      diff.colorWords = true;
    };
    lfs.enable = true;
  };
}
