{pkgs, lib, config, ...}:

let
  cfg = {
    podman = config.mynixos.podman;
    waydroid = config.mynixos.waydroid;
    docker = config.mynixos.docker;
  };
{
  options.mynixos.podman = lib.mkOption { 
    type = lib.types.bool;  
    default = false;
    description = "Enable podman";
  };

  options.mynixos.waydroid = lib.mkOption { 
    type = lib.types.bool;  
    default = false;
    description = "Enable waydroid and lxc also reqs wayland";
  };

  #options.mynixos.docker = lib.mkOption { 
  #  type = lib.types.bool;  
  #  default = false;
  #  description = "Enable docker";
  #};
  
  config = {
    virtualisation = {
      waydroid.enable = cfg.waydroid;
      podman = {
        enable = cfg.podman;
        dockerCompat = true;
        #defaultNetwork.settings.dns_enabled = true; # enables intercoms between cts.
      };
    };
  };
}
