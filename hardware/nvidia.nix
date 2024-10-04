{ config, lib, pkgs, ... }:

{
  # NOTE:
  # * Ensure unfree software support in nix
  # * Use X instead of wayland
  # * Ensure OpenGL is enabled for the X server

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
    # Force the use of an older NVIDIA driver?
    #
    # The 550 series of drivers causes issues (crashes, freezes, ...) - see
    # https://forums.developer.nvidia.com/t/series-550-freezes-laptop/284772/192
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.production;

    # Use the open driver?
    open = false;

    # Required by Wayland and to make reverse prime work properly
    modesetting.enable = true;

    # Adds nvidia-settings to the package list
    nvidiaSettings = true;

    # Power-management support
    powerManagement.enable = lib.mkOverride 999 true;
    # Fine-grained control is only allowed in prime offload configurations
    powerManagement.finegrained = lib.mkOverride 999 false;

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
  # Software
  #

  # Testing tools. Do not install. Use:
  #  * nix-shell -p vulkan-tools --run vkcube
  #  * nix-shell -p vdpauinfo --run vdpauinfo
  #  * nix-shell -p opencl-info --run opencl-info
  #  * nix-shell -p libva-utils --run vainfo

  # glxinfo is needed by the game-run script.
  environment.systemPackages = with pkgs; [ glxinfo ];
}
