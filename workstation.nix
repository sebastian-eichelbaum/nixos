# A common workstation setup. Installs NixOS and all the desktop tools, productivity and gaming stuff.

{ config, ... }:

{

  # The list of other modules to import. This is the spot where you can be
  # more or less specific on which modules get loaded.
  imports = [
    # The module that allows to configure the system
    ./system/SysConfig.nix

    # This is a workstation - to the common workstation setup
    ./system/workstation

    ###########################################################################
    # Modules
    # - The list of other modules to import. This is the spot where you can be
    #   more or less specific on which modules get loaded.

    # A gnome-based minimal desktop with AwesomeWM
    ./desktop

    # The minimal set of programs/services I use on all of my systems. cli baseline, c
    # oding tools, gaming, virtualization, ...
    ./programs
  ];
}
