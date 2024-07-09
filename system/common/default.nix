{ config, pkgs, lib, ... }:

{
  imports = [
    ../SysConfig.nix

    ./nixos.nix
    ./user.nix

    ./locale.nix
    ./network.nix
    ./services.nix
    ./programs.nix
  ];
}

