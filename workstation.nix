# A common workstation setup. Installs NixOS and all the desktop tools, productivity and gaming stuff.

{ config, ... }:

{
  # The list of other modules to import. This is the spot where you can be
  # more or less specific on which modules get loaded.
  imports = [
    # This is a workstation - to the common workstation setup
    ./system/workstation

    ###########################################################################
    # Modules
    # - The list of other modules to import. This is the spot where you can be
    #   more or less specific on which modules get loaded.

    # The minimal set of programs/services I use on all of my systems. cli baseline,
    # coding tools, gaming, virtualization, ...
    ./programs

    # A set of fixes and temporary solutions to make something work or fix up a package.
    # This should contain only a few files and should be updated regularly.
    ./quirks

    # A set of services to activate.
    ./services/syncthing.nix
  ];
}
