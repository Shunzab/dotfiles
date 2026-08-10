{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    (inputs.self + "/modules/home/alacritty.nix") 
    (inputs.self + "/modules/home/flatpak.nix")
    (inputs.self + "/modules/home/nvim.nix") 
    (inputs.self + "/modules/home/starship.nix") 
    (inputs.self + "/modules/home/terminal.nix") 
    (inputs.self + "/modules/home/tmux.nix") 
    (inputs.self + "/modules/home/zed.nix") 
  ];
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
