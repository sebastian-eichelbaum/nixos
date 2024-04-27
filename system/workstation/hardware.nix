{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Common Base Setup
  #

  # Hardware Platform. This is a default and can be modified in your machine-
  # specific configs.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Make the hardware clock local time. This fixes the time difference issues with windows
  time.hardwareClockInLocalTime = true;

  #############################################################################
  # Firmware things
  #

  # In general, load and apply firmware (like intel microcode, iwlwifi firmware, ...)
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Microcode updates? False by default - they consume quite some space.
  # Enable the correct one in the machine-specific config.
  hardware.cpu.intel.updateMicrocode = lib.mkDefault false;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault false;
}
