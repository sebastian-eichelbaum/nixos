{ config, pkgs, lib, ... }:

{
  imports = [
    ###########################################################################
    # Desktop Base
    #

    # Use awesome as window manager
    ./awesome.nix

    # Use a stripped down gnome as base
    ./gnome-core.nix

    # Make it look good
    ./theming.nix

    # Compositor Setup
    ./picom.nix

    ###########################################################################
    # Programs and Tools
    #

    # Add flatpak support
    ./flatpak.nix

    # And all the nice programs
    ./programs.nix

    # And all the nice game stuff
    ./gaming.nix

    # Syncthing
    ./syncthing.nix


    # Nix-LD to handle all the lib lookup for binaries
    ./nix-ld.nix
 ];
}
