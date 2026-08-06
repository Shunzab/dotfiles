{ config, pkgs, ... }:
# to add wms, and different kinds of dms only of wayland.
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

  extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver 
      OpenCL / Compute 
      intel-compute-runtime
    ];  
  };
}
