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
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;

    # Do not use the open source kernel module. It does not yet support
    # some features like reverse sync
    # open = false;

    # Required by wayland and to make reverse prime work properly
    modesetting.enable = true;

    # Adds nvidia-settings to the package list
    nvidiaSettings = true;

    # Powermanagement support
    powerManagement.enable = true;
    # ATTENTION: This actually works for cards > Ampere architecture
    # -> RTX 3000 series. See the modprobe config below.
    powerManagement.finegrained = true;

    # Enable prime
    prime = {
      # Use offload mode
      offload = {
        enable = true;
        # Adds nvidia-offload as a package
        enableOffloadCmd = true;
      };

      # Enable reverse prime? Seems to work without, same performance, displays
      # get recognized as expected.
      # reverseSync.enable = true;
      # sync.enable = true;

      # Bus IDs. To find those, use:
      # $ nix-shell -p lshw --run "lshw -c display"
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # As mentioned above, Cards below RTX 3000 require this module parameter
  # explicitly to enable proper power management.
  #boot.extraModprobeConfig = ''
  #  options nvidia NVreg_DynamicPowerManagement=0x02
  #'';

  #############################################################################
  # Specialization to boot the NVIDIA as the primary GPU
  #

  specialisation = {
    NVIDIA.configuration = {
      system.nixos.tags = [ "NVIDIA" ];
      # Disable all the prime offload features to make this work
      hardware.nvidia = {
        # Disable power management. Not compatible.
        powerManagement.enable = lib.mkForce false;
        powerManagement.finegrained = lib.mkForce false;

        # No offloading needed as the NVIDIA GPU is the only used GPU.
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;

        # Enable reverse prime enables the internal display.
        # prime.reverseSync.enable = lib.mkForce true;
      };
    };
  };

  #############################################################################
  # Additional Power Management
  #

  /* OLD NVIDIA udev rules. Still needed?
     # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
     ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
     ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

     # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
     ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
     ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
  */

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
