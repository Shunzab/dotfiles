{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd"; # or "scx_bpfland"
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs.steam = {
    enable = true;

    dedicatedServer.openFirewall = true;
    #localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general.renice = 10;
      gpu.apply_gpu_optimisations = "accept-responsibility";
    };
  };

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;
}
