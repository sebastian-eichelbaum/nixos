{ config, pkgs, lib, ... }:

{
  imports = [
    # System setup. This creates the basic system. Import these to create a 
    # functional base system.

    ./hardware.nix

    ./user.nix

    ./nixos.nix
    ./bootloader.nix
    ./network.nix
    ./security.nix

    ./locale.nix

    ./input.nix
    ./sound.nix
    ./xserver.nix
    ./bluetooth.nix

    ./programs.nix
    ./services.nix
  ];
}

