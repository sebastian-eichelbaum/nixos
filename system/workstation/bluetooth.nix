{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Bluetooth
  #

  # Enable bluetooth support
  hardware.bluetooth = {
    enable = true;

    # Off by default.
    # NOTE: blueman applet provides a plugin to turn bluetooth on automatically
    powerOnBoot = false;
  };

  # Use the blueman tools - required if not using gnome or KDE to manage bt
  services.blueman.enable = true;

  # Start blueman applet per session
  services.xserver.displayManager.sessionCommands = ''
    blueman-applet &
  '';
}
