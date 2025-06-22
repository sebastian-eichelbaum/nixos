{ config, pkgs, lib, ... }:

{
  imports = [
    # Mandatory. Everything needed for my dotfiles to work
    ./cli.nix

    # A nice but not blown desktop
    ./desktop.nix

    # Games and GameMode
    ./gaming.nix

    # Work stuff
    ./coding.nix
    ./virtualisation.nix

    # AI Tools
    ./ai.nix
  ];
}
