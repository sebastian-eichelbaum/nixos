# Your custom machine setup.
#
# This file is not in git and contains your setup and some secrets.

{ config, pkgs, ... }:

{
  # Configure YOUR system in here. Check `system/SysConfig.nix` for a complete 
  # list of options and their description.
  SysConfig = {

    ###########################################################################
    # System
    #

    # See: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    #
    # For a new, fresh install: set to the current release and KEEP it there.
    stateVersion = "23.05"; # Did you read the comment?

    # The hostname
    hostName = "worky";

    # The platform this is running on
    hostPlatform = "x86_64-linux";

    ###########################################################################
    # Users
    #

    # The single main user:
    user = {
      realName = "Sebastian";

      # Login name
      name = "seb";

      # Use mkpasswd. (Considered a secret!)
      passHash = "abcdefghijklmnopqrstuvwxyz";

      # Additonal user groups. Also check system/user.nix
      extraGroups = [ ];
    };

    # Use mkpasswd. (Considered a secret!)
    root = { passHash = "abcdefghijklmnopqrstuvwxyz"; };

    ###########################################################################
    # Features
    #

    # Syncthing: The device ID of the syncthing server to use. If unset, syncthing
    # is disabled. (Considered a secret!)
    syncthing.serverId = "123123-adssfdsd-321123-asfghdfg-234234234-sdfsdfdsf";
  };

  # Add more packages:
  environment.systemPackages = with pkgs; [ ];

  # The list of other modules to import. This is the spot where you can be
  # more or less specific on which modules get loaded.
  imports = [
    # This is a workstation - to the common workstation setup is provided in here.
    ./workstation.nix

    # The module that defines the actual machine setup. This includes hardware
    # configs, disk setup, ... everything you need physically to have a machine
    # that boots and runs a linux kernel.
    ./machines/RazerBlade15_Advanced_Late2020.nix

    ###########################################################################
    # Custom modules
    #

    # ...
  ];
}
