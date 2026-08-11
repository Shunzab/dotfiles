{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  is_zsh_enabled = config.programs.zsh.enable or false;
  user_shell = if is_zsh_enabled then pkgs.zsh else pkgs.bash;
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
