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

    # Mime setup
    ./mime.nix

    ###########################################################################
    # Programs and Tools
    #

    # Add flatpak support
    ./flatpak.nix

    # Nix-LD to handle all the lib lookup for binaries
    ./nix-ld.nix
 ];
}
