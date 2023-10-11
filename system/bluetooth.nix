{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Bluetooth
  #

  # Enable bluetooth support
  hardware.bluetooth.enable = true;

  # Use the blueman tools - required if not using gnome or KDE to manage bt
  services.blueman.enable = true;

  # Start blueman applet per session
  services.xserver.displayManager.sessionCommands = ''
    blueman-applet &
  '';
}
