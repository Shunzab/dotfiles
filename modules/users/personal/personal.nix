{config, lib, pkgs, ...}:

{
  users.mutableUsers = false;
  users.users = {
    srs = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    }
  };
  config = lib.mkIf (config ? home-manager) {
    home-manager.users.srs = import ./profiles/home.nix;
  };
}

