{ config, lib, pkgs, ... }:

{
  imports = [
    # Requires the base NVidia config. On Dual-GPU laptops, this causes the internal display to stay black.
    ./nvidia.nix
  ];

  # Regarding the PRIME modes:
  #
  # There are 2 ways to use this. They are mutually exclusive.
  #
  # 1. Manual offload mode. Call the offload script to push something to the GPU.
  #     Advantage: Most power efficient. The GPU is fully asleep when not in use.
  #     Drawback:  slight performance hit.
  #
  # 2. Sync Mode. Intel GPU is primary but keep it in sync with the NVidia
  #     Advantage: Better performance and the NVidia display outputs are available.
  #     Drawback:  Way worse power consumption!
  #
  # There is a third mode. Reverse Sync. It allows you to utilize the internal GPU outputs (a.k.a. the laptop screen) to
  # be used if not in sync and not in offload mode. You might also want to enable it if in offline mode and the external
  # displays are not showing up. On Systems with a MUX switch, this seems not to be required?

  # The default config in nvidia.nix disables prime. For a laptop, that is mostly docked, this is fine. While on the
  # move, this config adds a "Mobile" specialization to boot into prime offload mode.

  #############################################################################
  # Prime Reverse Sync Setup
  #

  # This is the most sensible default for an expensive, mostly docked laptop. Enable the NVidia GPU. Make the internal
  # GPU sync to the NVidia GPU. This yields most performance while still keeping the internal display available.
  hardware.nvidia = {
    prime = {
      # Make the internal display available:
      reverseSync.enable = true;

      # The default script triggers 'xrandr --auto' after setting up reverse sync. This makes sense as it provides an
      # image on previously disabled screens. A common scenario: booting the laptop in NVidia-only mode. The internal
      # screen stays black. That's bad. xrandr --auto prevents this from happening.
      #
      # When using autorandr though, this causes a LOT of screen on/off flicker when booting.
      reverseSync.setupCommands.enable = !config.services.autorandr.enable;
    };
  };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/hardware/video/nvidia.nix
  #
  # WARNING: not working with AMD GPUs
  # services.xserver.displayManager.setupCommands = lib.mkBefore ''
  #   ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource NVIDIA-G0 modesetting
  # '';

  #############################################################################
  # Prime Offload Setup
  #

  # Provide this as a specialization to the default config.
  # It disables any sync methods and only configures offloading.
  specialisation = {
    Mobile.configuration = {
      system.nixos.tags = [ "Mobile" ];

      # The most power efficient setup:
      hardware.nvidia = {
        # Also enable fine-grained power-management support
        powerManagement.finegrained = lib.mkForce true;

        prime = {
          offload = {
            enable = lib.mkForce true;
            enableOffloadCmd = lib.mkForce true;
          };
        };
      };
    };
  };
}
