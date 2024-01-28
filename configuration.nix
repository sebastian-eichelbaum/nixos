# Do not edit this file for a specific machine. Instead
#  - edit machine for Hardware specifics
#  - create and edit programs.nix for setting up the required software

{ config, pkgs, lib, ... }:

{
  imports = [
    # Generated by the installer. Should not be used directly! Use a file in
    # hosts-dir instead.
    # ./hardware-configuration.nix

    # Specific hardware setup
    ./machine.nix
    ./users.nix

    # System setup. Import these to create a  functional base system.
    # This also installs some common tools, like git and nvim.
    ./system

    # Desktop setup. Uses X.
    ./desktop

    # A customized list of programs to install on this machine. Create this
    # and import stuff from ./programs
    ./programs.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #
  # Referr: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05"; # Did you read the comment?

}
