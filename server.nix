# A common server setup. Installs NixOS without X and all the software. Most things are NOT
# insatled by default. You have to be selective in your config.

{ config, ... }:

{

  # The list of other modules to import. This is the spot where you can be
  # more or less specific on which modules get loaded.
  imports = [
    # This is a server
    ./system/server

    ###########################################################################
    # Modules
    # - The list of other modules to import. This is the spot where you can be
    #   more or less specific on which modules get loaded.

    # The minimal set of programs/services
    #./programs

    # A set of fixes and temporary solutions to make something work or fix up a package.
    # This should contain only a few files and should be updated regularly.
    # ./quirks

    # A set of services to activate.
    # ./services/syncthing.nix
  ];
}
