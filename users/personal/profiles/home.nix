{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    (inputs.self + "/home/alacritty.nix")
    (inputs.self + "/home/flatpak.nix")
    (inputs.self + "/home/nvim.nix")
    (inputs.self + "/home/starship.nix")
    (inputs.self + "/home/terminal.nix")
    (inputs.self + "/home/tmux.nix")
    (inputs.self + "/home/zed.nix")
  ];
  home.username = "srs";
  home.homeDirectory = "/home/srs";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05"; # no changing this

  stylix.targets = {
    tmux.enable = false;
    alacritty.enable = true;
    starship.enable = true;
    zed.enable = true;
  };

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
    settings.user = {
      email = "shunzab.asad@gmail.com";
      name = "Shunzab Asad";
    };

    settings = {
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3"; # Modern 3-way merge conflict style
      diff.colorWords = true;
    };
    lfs.enable = true;
  };
}
