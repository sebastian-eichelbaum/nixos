{ config, pkgs, lib, ... }:

{
  imports = [
    # Use awesome as window manager
    ./awesome.nix
    # Use a stripped down gnome as base   
    ./gnome-core.nix

    # Make it look good
    ./theming.nix

    # Add flatpak support
    ./flatpak.nix

    # And all the nice programs
    ./programs.nix

    # And all the nice game stuff
    ./gaming.nix

    # Syncthing
    ./syncthing.nix
  ];
}
