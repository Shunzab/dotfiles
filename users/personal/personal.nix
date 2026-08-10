{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  user_shell = if (pkgs ? zsh) then pkgs.zsh else pkgs.bash;
  has_home_manager = options ? home-manager;
in
{
  users.mutableUsers = false;

  users.users.srs = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = user_shell;
    initialPassword = "changeme";
  };

  home-manager = lib.mkIf has_home_manager {
    users.srs = import ./profiles/home.nix;
  };
}
