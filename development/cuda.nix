{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Development: Cuda
  #

  # NOTE: this requires the nvidia config in hardware/nvidia***.nix
  environment.systemPackages = with pkgs; [
    # The cuda tools
    cudatoolkit

    # Libraries:

    # Random number generation
    cudaPackages.libcurand
  ];

  # IMPORTANT: many tools require cuda and the nvidia libs to be in their lib paths.
  #
  # Refer to nix-ld.nix for more details. DO NOT use nix-ld for cudatoolkit.
}
