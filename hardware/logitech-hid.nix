{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Logitech Unifying and Bolt support
  #

  # Some UDEV rules and solaar
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
}

