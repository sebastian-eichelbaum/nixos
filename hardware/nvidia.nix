{ config, lib, pkgs, ... }:

{
  # NOTE:
  # * Ensure unfree software support in nix
  # * Use X instead of wayland
  # * Ensure OpenGL is enabled for the X server

  imports = [
    # Fix some of the driver quirks
    ../quirks/nvidia_fixes.nix
  ];

  #############################################################################
  # Hardware Setup
  #

  # Looks wrong as we actually should use "modesetting" for intel too. The doc
  # states that this should be done this way as nix does not know about
  # multiple GPU.
  #
  # Watch https://github.com/NixOS/nixpkgs/issues/108018 for updates
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  # NVIDIA specific setup. Ensure unfree packages
  hardware.nvidia = {
    # A driver version:
    #
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Use the open driver?
    open = false;

    # Enable modeset and fbdev for the nvidia-drm driver. This sets the kernel params nvidia-drm.modeset and
    # nvidia_drm.fbdev to be 1.
    #
    # Is required for autorandr to work. Without this, udev is not able to detect changes in connected displays.
    modesetting.enable = lib.mkOverride 999 true;

    # Adds nvidia-settings to the package list
    nvidiaSettings = true;

    # Power-management support
    powerManagement.enable = lib.mkOverride 999 true;
    # Fine-grained control is only allowed in prime offload configurations
    powerManagement.finegrained = lib.mkOverride 999 false;
    # Shifts power between CPU and GPU. Disabled by default (for a reason?)
    dynamicBoost.enable = lib.mkOverride 999 true;

    prime = {
      # Disable offloading
      offload.enable = lib.mkOverride 999 false;
      offload.enableOffloadCmd = lib.mkOverride 999 false;

      # Disable Sync and reverse sync to disable prime overall
      sync.enable = lib.mkOverride 999 false;
      reverseSync.enable = lib.mkOverride 999 false;

      # Bus IDs. To find those, use:
      # $ nix-shell -p lshw --run "lshw -c display"
      intelBusId = config.SysConfig.hardware.nvidia.prime.intelBusId;
      nvidiaBusId = config.SysConfig.hardware.nvidia.prime.nvidiaBusId;
    };
  };

  #############################################################################
  # Required Software
  #

  # Enable VAAPI
  hardware.graphics.extraPackages = with pkgs; [ nvidia-vaapi-driver ];

  #############################################################################
  # CUDA
  #

  # Enable support in installed packages globally? DO NOT DO THIS.
  # nixpkgs.config.cudaSupport = true;

  # Do not set cudaSupport globally! This will cause a huge re-build (Cuda=Unfree, so its not cached by Nix)
  # Instead, activate CUDA for those packages where you need it:
  #
  # environment.systemPackages = with pkgs; [
  #  (pkgs.btop.override { cudaSupport = true; })
  # ];

  # Ensure programs find these libs
  programs.nix-ld.libraries = with pkgs; [
    cudatoolkit
    cudaPackages.libcublas
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    cudaPackages.libcurand
  ];

  #############################################################################
  # Software
  #

  environment.systemPackages = with pkgs; [
    ##########################################################################
    # Cuda

    # Install the toolkit itself and some CUDA libs that are very common
    cudatoolkit
    cudaPackages.libcublas
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    cudaPackages.libcurand

    ##########################################################################
    # Testing tools

    # glxinfo is needed by the game-run script.
    mesa-demos
    #vkcube
    #vdpauinfo
    #opencl-info
    #vainfo

    # Show GPU Usage: nvtop
    nvtopPackages.full
  ];
}
