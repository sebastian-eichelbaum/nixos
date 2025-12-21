{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Hardware Setup
  #

  # amdgpu to be used in X - using this explicitly to avoid issues with variable
  # refresh rate displays.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable overclocking support for AMD GPUs. Required for tools like LACT to work.
  hardware.amdgpu.overdrive.enable = true;

  #############################################################################
  # Compute Setup
  #

  # Enable OpenCL for AMD GPU
  hardware.amdgpu.opencl.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
  ];

  # Shown in https://wiki.nixos.org/wiki/AMD_GPU
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
    };
  in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];

  # Ensure programs find these libs
  programs.nix-ld.libraries = with pkgs; [
    # !!
    rocmPackages.rocm-runtime
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.hipblas
    rocmPackages.hipcc
    rocmPackages.hiprt
    rocmPackages.rocblas
    rocmPackages.llvm.openmp
  ];

  #############################################################################
  # Software
  #

  services.lact.enable = true;

  # Enable ROCm support
  environment.systemPackages = with pkgs; [
    ##########################################################################
    # ROCm Software Stack

    rocmPackages.rocm-runtime
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.hipblas
    rocmPackages.hipcc
    rocmPackages.hiprt
    rocmPackages.rocblas
    rocmPackages.llvm.openmp

    ##########################################################################
    # Testing tools

    # Show GPU Usage: nvtop
    nvtopPackages.amd
    rocmPackages.rocminfo

    # Overclocking and Power Management
    lact
  ];

  #############################################################################
  # Quirks and fixes.
  #
  #  - These fix issues with that hardware but might be obsolete soon.
  #    Check regularly.
  #

}
