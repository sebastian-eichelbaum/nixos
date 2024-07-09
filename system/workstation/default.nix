{ config, pkgs, lib, ... }:

{
  imports = [
    ../common

    # System setup. This creates the basic system. Import these to create a
    # functional base system.

    ./hardware.nix

    ./user.nix

    ./bootloader.nix
    ./network.nix
    ./security.nix

    ./input.nix
    ./sound.nix
    ./xserver.nix
    ./bluetooth.nix

    ./services.nix

    # Workstations have a desktop
    ./desktop
  ];
}

