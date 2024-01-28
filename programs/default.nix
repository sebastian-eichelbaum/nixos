{ config, pkgs, lib, ... }:

{
  imports = [
    # Mandatory. Everything needed for my dotfiles to work
    ./cli.nix

    # A nice but not blown desktop
    ./desktop.nix
    # Syncthing service config - provides sync for the shared folder and photos
    ./syncthing.nix

    # Games and GameMode
    ./gaming.nix

    # Work, all the Coding  and GameMode
    ./coding.nix

  ];
}
